#!/usr/bin/env bash

SCRIPTNAME="$0"
VERSION="0.0.1"
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

source "$SCRIPTS_DIR/util/base.sh"
source "$SCRIPTS_DIR/util/logging.sh"
source "$SCRIPTS_DIR/util/config.sh"
source "$SCRIPTS_DIR/util/api.sh"
source "$SCRIPTS_DIR/util/dns.sh"

REQUIRES_FUNCS \
    debug info warn error log_start \
    config_load_all config_validate \
    merge_arrays repeated

# shellcheck disable=SC2034
HELP_TEXT="
    $SCRIPTNAME v$VERSION

    Helper script to update a DNS record on multiple providers.

Usage:
    $SCRIPTNAME --domain=domain.example.com [--get|--set=value] [...options]

Options:
    [domain]               The DNS domain you want to get or set (required)

    --domain=example.com   Same as passing [domain] directly as an argument
    -t=|--type=A           The DNS record type, e.g. A, CNAME, etc. (A default)

    -g|--get               Get the record value (the default)
    -s=|--set=value        Set the record value, e.g. 123.235.324.234 or the
                             special value 'pubip' to use current public ip


    -l=|--ttl=n            Set the record TTL to n seconds (overrides api default)
    -p=|--proxied          Set the record to be proxied through CDN (Cloudflare only)
    -a=|--api=cf,do        List of DNS providers to use, e.g. all (default) or cf,do
    -r=|--refresh=n        Run continusouly every n seconds in a loop
    -w=|--timeout=n        Wait n seconds before aborting and retrying
    
    -c=|--config=file      Path to a dotenv-formatted config file to load
    -e=|--config-prefix=X  Load config vars with prefix X e.g. X_VERBOSE=1

    -h|--help              Show this help message
    -v|--verbose           Show more verbose output
    -q|--quiet             Supress all output except for errors and warnings
    --color                Force showing of colors in the stderr output
    --nocolor              Force hiding of colors in the stderr output
    --notimestamps         Force hiding of timestamps in stderr output
    --nologlevels          Force hiding of log levels in stderr output

Config:                   (passed via --config=file or environment variables)
    DOMAIN=a.example.com  Same as --domain option


    CF_API_KEY=12345      Clouflare API token:      https://dash.cloudflare.com/<account_id>/profile/api-tokens
    DO_API_KEY=12345      DigitalOcean API token:   https://cloud.digitalocean.com/account/api/tokens
    
    VEBOSE=1              Show debug output [0]/1
    QUIET=0               Hide info output: [0]/1
    COLOR=1               Colorize stderr output: [1]/0
    TIMEOUT=15            Seconds to wait before aborting and retrying

Examples:
    $SCRIPTNAME abc.example.com
    $SCRIPTNAME abc.example.com --get --refresh=30
    $SCRIPTNAME abc.example.com --type=A --set=pubip --ttl=300 --api=digitalocean --config=~/.digitalocean.env
    $SCRIPTNAME --domain=abc.example.com --type=A --set=1.2.3.4 --api=digitalocean,cloudflare --refresh=30 --config=./secrets.env


"

### Default Config
API_KEY_PLACEHOLDER="set-this-value-in-your-config-file"
ALLOWED_APIS='cf,do'


# shellcheck disable=SC2034
declare -A DNS_CLI_ARGS=(
    # Flag Arguments
    [GET]='-g|--get'
    [PROXIED]='-p|--proxied'
    
    # Named Arguments
    [DOMAIN]='-d|--domain|-d=*|--domain=*'
    [TYPE]='-t|--type|-t=*|--type=*'
    [SET]='-s|--set|-s=*|--set=*'
    [TTL]='-l|-l=*|--ttl|--ttl=*'
    [API]='-a|-a=*|--api|--api=*'

    # Positional Arguments
    # [DOMAIN]='*'
    # [TYPE]='*'
    # [SET]='*'
)
merge_arrays CLI_ARGS BASE_CLI_ARGS DNS_CLI_ARGS

# shellcheck disable=SC2034
declare -A DNS_CONFIG_DEFAULTS=(
    [DOMAIN]=''
    [TYPE]='A'
    [GET]=''
    [SET]=''

    [API]='all'
    [TTL]='default'
    [PROXIED]='false'

    [CF_API_KEY]="$API_KEY_PLACEHOLDER"
    [CF_DEFAULT_TTL]=1

    [DO_API_KEY]="$API_KEY_PLACEHOLDER"
    [DO_DEFAULT_TTL]=300
)
merge_arrays CONFIG_DEFAULTS BASE_CONFIG_DEFAULTS DNS_CONFIG_DEFAULTS
declare -A CONFIG

# shellcheck disable=SC2016 disable=SC2034
declare -A CONFIG_VALIDATORS=(
    [DOMAIN]='[[ "${CONFIG[DOMAIN]}" ]]'
    [TYPE]='[[ "${CONFIG[TYPE]}" ]]'
    [SET]='validate_set_config'
    [API]='validate_api_config'
)
merge_arrays CONFIG_VALIDATORS BASE_CONFIG_VALIDATORS DNS_CONFIG_VALIDATORS


function validate_set_config {
    if [[ ! "${CONFIG[GET]}" && ! "${CONFIG[SET]}" ]]; then
        fatal "Missing --get or --set=value argument (pass --help for usage and examples)."
    fi

    if [[ "${CONFIG[SET]}" && "${CONFIG[TYPE]}" == 'A' ]]; then
        if ! [[ "${CONFIG[SET]}" == 'pubip' ]] || echo "${CONFIG[SET]}" | grep -q "$IPV4_REGEX"; then
            error "Invalid value --set=${CONFIG[SET]} must be pubip or an ip address"
            return 1
        fi
    fi
    return 0
}

function validate_api_config {
    local APIS="${CONFIG[API]}"

    for API in ${APIS//,/ }; do
        case "$API" in
            'digitalocean'|'do')
                [[ "${CONFIG[DO_API_KEY]}" == "$API_KEY_PLACEHOLDER" ]] && {
                    error "You must pass your DO_API_KEY via environment variable or --config=file.env (pass --help for more info)."
                    return 1
                }
                ;;
            'cloudflare'|'cf')
                [[ "${CONFIG[CF_API_KEY]}" == "$API_KEY_PLACEHOLDER" ]] && {
                    error "You must pass your CF_API_KEY via environment variable or --config=file.env (pass --help for more info)."
                    return 1
                }
                ;;
            'all')
                CONFIG[API]="$ALLOWED_APIS"
                ;;
            *)
                error "Unrecognized API type '$API'. (must be one or more of: $ALLOWED_APIS)"
                return 1
                ;;
        esac
    done
    return 0
}


### Main Functions

function get_record {
    local API="$1" DOMAIN="$2" TYPE="$3"


    if [[ "$API" == "do" ]]; then
        . ./lib/digitalocean.sh
    elif [[ "$API" == "cf" ]]; then
        . ./lib/cloudflare.sh
    fi

    dns_get_record "$DOMAIN" "$TYPE"
}

function update_record {
    local API="$1" DOMAIN="$2" TYPE="$3" VALUE="$4" TTL="$5" PROXIED="$6"

    local VALUE_BEFORE VALUE_AFTER STATUS

    [[ "$VALUE" == "pubip" ]] && VALUE="$(get_public_ip)"             # replace pubip with actual ip

    if [[ "$TYPE" == "TXT" ]]; then
        VALUE="$(echo "$VALUE" | perl -pe 's/\n/\\\n/gm')"
    fi

    if [[ "$API" == "do" ]]; then
        . ./lib/digitalocean.sh
    elif [[ "$API" == "cf" ]]; then
        . ./lib/cloudflare.sh
    fi

    VALUE_BEFORE="$(
            dns_get_record \
                "$DOMAIN" \
                "$TYPE"
    )" && STATUS="$?" || STATUS="$?" 

    if [[ "$STATUS" == "8" ]]; then
        warn "$API/$DOMAIN/$TYPE=$VALUE creating new record..."
        VALUE_AFTER="$(
            dns_create_record \
                "$DOMAIN" \
                "$TYPE" \
                "$VALUE" \
                "$TTL" \
                "$PROXIED"
        )"
    elif ((STATUS>0)); then
        fatal --status=$STATUS "dns_get_record return an invalid exit status $STATUS"
    elif [[ "$VALUE_BEFORE" == "$VALUE" ]]; then
        info "$API/$DOMAIN/$TYPE=$VALUE_BEFORE is up-to-date."
        return 0
    else
        info "$API/$DOMAIN/$TYPE=$VALUE_BEFORE updating to $VALUE..."
        
        VALUE_AFTER="$(
            dns_set_record \
                "$DOMAIN" \
                "$TYPE" \
                "$VALUE" \
                "$TTL" \
                "$PROXIED"
        )"
    fi
    
    if ! [[ "$VALUE_AFTER" == "$VALUE" || "$VALUE_AFTER" == "${VALUE}." ]]; then
        error "$API/$DOMAIN/$TYPE=$VALUE update failed (got ${VALUE_AFTER:-API error})."
        return 1
    else
        info "$API/$DOMAIN/$TYPE=$VALUE update succeeded."
        return 0
    fi
}

function log_start_dns {
    config_assert INTERVAL API DOMAIN TYPE

    local INTERVAL_STR

    # Begin check/update process
    ((CONFIG[INTERVAL]>0)) && INTERVAL_STR="every ${CONFIG[INTERVAL]}s" || INTERVAL_STR="once"
    if [[ "${CONFIG[SET]}" ]]; then
        info "Starting: SET ${CONFIG[API]}/${CONFIG[DOMAIN]}/${CONFIG[TYPE]}=${CONFIG[SET]} $INTERVAL_STR..."
    else
        info "Starting: GET ${CONFIG[API]}/${CONFIG[DOMAIN]}/${CONFIG[TYPE]} $INTERVAL_STR..."
    fi
}

function runloop {
    local APIS="${CONFIG[API]}"

    GET="${CONFIG[GET]}"
    SET="${CONFIG[SET]}"

    for API in ${APIS//,/ }; do
        if ((GET==1)); then
            timed "${CONFIG[TIMEOUT]}" \
                get_record \
                    "$API" \
                    "${CONFIG[DOMAIN]}" \
                    "${CONFIG[TYPE]}"
            return $?
        elif [[ "$SET" ]]; then
            timed "${CONFIG[TIMEOUT]}" \
                update_record \
                    "$API" \
                    "${CONFIG[DOMAIN]}" \
                    "${CONFIG[TYPE]}" \
                    "${CONFIG[SET]}" \
                    "${CONFIG[TTL]}" \
                    "${CONFIG[PROXIED]}"
            return $?
        else
            fatal 'You must pass either --get or --set=value'
        fi
    done
}


function main {
    # Load config from file, env variables, and kwargs
    config_load_all CONFIG_DEFAULTS CLI_ARGS "$@"
    config_validate CONFIG_VALIDATORS
    log_start_dns

    repeated "${CONFIG[INTERVAL]}" runloop
}

main "$@"
#wait "$!" && STATUS=$? || STATUS=$?
#jobs -p >/dev/null 2>&1
#jobs -p | xargs 'kill -9 --' >/dev/null 2>&1

#if ((STATUS>125)); then
    # codes >= 125 are used by the shell only and cannot be returned from scripts
    # https://www.tldp.org/LDP/abs/html/exitcodes.html
#    exit $((STATUS-100))
#else
#    exit $STATUS
#fi
