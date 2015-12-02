"=============================================================================
" FILE: autoload/data/linkedlist.vim
" AUTHOR: haya14busa
" License: MIT license
" DESCRIPTION: Linked list implementation https://en.wikipedia.org/wiki/Linked_list
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('algorithms_and_data_structures')
execute s:V.import('Vim.PowerAssert').define('Assert')
let s:assert = s:V.import('Vim.PowerAssert').assert

function! data#LinkedList#import() abort
  return s:
endfunction

" s:None is custom None data type.
" @type none
let s:None = { 'type': 'None' }

" s:is_none() returns true if given element is None, otherwise returns false.
" @param x: <any>
" @return boolean
function! s:is_none(x) abort
  return type(a:x) is# type({}) && get(a:x, 'type', '') is# 'None'
endfunction

" @type { data: <any>, next: <Node|none>, prev: <Node|none> }
let s:Node = { 'next': s:None, 'prev': s:None  }

" s:Node.new() returns new Node instance with given data.
" @param data: <any>
function! s:Node.new(data) abort
  let node = deepcopy(self)
  let node.data = a:data
  return node
endfunction

" @param node: <Node|none>
function! s:Node.set_next(node) abort
  let self.next = a:node
  if !s:is_none(a:node)
    let a:node.prev = self
  endif
endfunction

" @type { head: <Node|none>, last: <Node|none> }
let s:LinkedList = { 'head': s:None, 'last': s:None }

" .new() returns new LinkedList instance.
function! s:LinkedList.new() abort
  return deepcopy(self)
endfunction

" .add_first() adds given data to the head of LinkedList.
" @param data: <any>
function! s:LinkedList.add_first(data) abort
  let new_node = s:Node.new(a:data)
  call new_node.set_next(self.head)
  if s:is_none(self.head)
    let self.last = new_node
  endif
  let self.head = new_node
endfunction

" .add_last() adds given data to the last of LinkedList.
" @param data: <any>
function! s:LinkedList.add_last(data) abort
  let new_node = s:Node.new(a:data)
  if !s:is_none(self.last)
    call self.last.set_next(new_node)
    let self.last = new_node
  else
    let self.head = new_node
    let self.last = new_node
  endif
endfunction

" .remove_first() removes and returns the first element from LinkedList.
" @return <any>
function! s:LinkedList.remove_first() abort
  "= pre condition ===
  let _pre_size = self.size()
  let _pre_list = deepcopy(self)
  Assert self.size() > 0
  "===================
  let target = self.head
  let result = target.data
  let self.head = target.next
  if s:is_none(self.head)
    let self.last = self.head
  endif
  "= post condition ==
  Assert self.size() is# _pre_size - 1
  let _post_list = deepcopy(self)
  call _post_list.add_first(result)
  Assert _post_list.to_string() ==# _pre_list.to_string()
  "===================
  return result
endfunction

" .add() adds the specified data at the specified position in this list.
" @param data: <any>
function! s:LinkedList.add(index, data) abort
  if a:index < 0 || a:index > self.size()
    throw 'IndexOutOfBoundsException'
  endif

  if a:index is# 0
    call self.add_first(a:data)
    return
  endif

  if a:index is# self.size()
    call self.add_last(a:data)
    return
  endif

  let new_node = s:Node.new(a:data)
  let target_next = self.head
  for _ in range(a:index)
    let target_next = target_next.next
  endfor
  let target_prev = target_next.prev
  if !s:is_none(target_prev)
    call target_prev.set_next(new_node)
  endif
  call new_node.set_next(target_next)
endfunction

" .size() returns size of LinkedList.
function! s:LinkedList.size() abort
  let cnt = 0
  let current = self.head
  while !s:is_none(current)
    let cnt += 1
    let current = current.next
  endwhile
  return cnt
endfunction

" .to_string() returns string representation of LinkedList.
function! s:LinkedList.to_string() abort
  let str = '['
  let current = self.head
  if !s:is_none(current)
    let str .= string(current.data)
    let current = current.next
  endif
  while !s:is_none(current)
    let str .= ', ' . string(current.data)
    let current = current.next
  endwhile
  let str .= ']'
  return str
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
