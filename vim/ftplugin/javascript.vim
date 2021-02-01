" make Vim recognize ES6 import statements
let &l:include = 'from\|require'

" allow Vim to parse path aliases such as ~/components or @/components
" which are common in Vue projects
setlocal isfname+=@-@
setlocal suffixesadd+=.vue
let &l:includeexpr = "path#resolve_alias(['~', '@'], ['src', 'app'], v:fname)"

" make Vim use ES6 export statements as define statements
let &l:define = '\v(export\s+(default\s+)?)?(var|let|const|(async\s+)?function|class)|export\s+'

setlocal textwidth=80

" define convenience sniplets
let s:snippets_map={
  \ "log": "console.log(",
  \ "warn": "console.warn(",
  \ "json": "JSON.stringify",
  \ "jlog": "console.log(JSON.stringify(, null, 2))\<C-o>2F,",
  \ "fn": "() => {}",
  \ "if": "if () {\<CR>\<C-o>k\<C-o>f)",
  \ "ifelse": "if () {\<CR>\<C-o>j else {\<CR>\<C-o>3k\<C-o>f)",
  \ "try": "try {\<CR>\<C-o>j catch (error) {\<CR>\<C-o>{\<C-f>",
  \ "tryf": "try {\<CR>\<C-o>j catch (error) {\<CR>\<C-o>j finally {\<CR>\<C-o>2{\<C-f>",
  \ "pobj": "PropTypes.object",
  \ "pfn": "PropTypes.func",
  \ "parr": "PropTypes.arrayOf(",
  \ "pstr": "PropTypes.string",
  \ "pbool": "PropTypes.bool",
  \ "pshape": "PropTypes.shape({",
  \ "pnum": "PropTypes.number",
  \ "pany": "PropTypes.any",
  \ "pnode": "PropTypes.node",
  \ "pone": "PropTypes.oneOf([",
  \ "ptypes": "static propTypes = {",
  \ "defprops": "static defaultProps = {",
  \ "ctypes": "static contextTypes = {",
  \ "constructor": "constructor(props) {
super(props);",
  \ "cwm": "componentWillMount() {",
  \ "cdm": "componentDidMount() {",
  \ "scu": "shouldComponentUpdate(nextProps, nextState) {",
  \ "cwrp": "componentWillReceiveProps(nextProps) {",
  \ "cwu": "componentWillUpdate() {",
  \ "cdu": "componentDidUpdate() {",
  \ "cwum": "componentWillUnmount() {",
  \ }

for [s:pattern, s:expansion] in items(s:snippets_map)
  execute "ISnipletBuffer" s:pattern s:expansion
endfor

CSnipletBuffer json JSON.stringify
CSnipletBuffer warn console.warn
CSnipletBuffer log console.log

" define convenience map for destructuring
inoremap <buffer> <C-@>xx ;<C-o>Bconst {} = <C-o>F}<Space><Space><Left>
inoremap <buffer> <C-@>xi ';<C-o>B'<Left>import {} from <C-o>F}

" define convenience map for passing down handler props
inoremap <buffer> <C-@>xp <C-o>"zyiw<C-r>z={<End>}
  \<C-o>:keeppatterns s/handle/on<CR><End>

" allow filename completion with import * from ../<C-x><C-f>
call cwd#ChangeOnInsert()
