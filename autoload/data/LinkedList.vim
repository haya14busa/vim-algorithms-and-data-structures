"=============================================================================
" FILE: autoload/data/linkedlist.vim
" AUTHOR: haya14busa
" License: MIT license
" DESCRIPTION: Linked list implementation https://en.wikipedia.org/wiki/Linked_list
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! data#LinkedList#import() abort
  return s:
endfunction

" s:None is custome None data type.
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

" .add_first() addes given data to the head of LinkedList.
" @param data: <any>
function! s:LinkedList.add_first(data) abort
  let new_node = s:Node.new(a:data)
  call new_node.set_next(self.head)
  if s:is_none(self.head)
    let self.last = new_node
  endif
  let self.head = new_node
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

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
