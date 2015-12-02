"=============================================================================
" FILE: autoload/data/Stack.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('algorithms_and_data_structures')
execute s:V.import('Vim.PowerAssert').define('Assert')
let s:assert = s:V.import('Vim.PowerAssert').assert

let s:LinkedList = data#LinkedList#import().LinkedList

function! data#Stack#import() abort
  return s:
endfunction

let s:Stack = {}

" .new() returns new Stack instance.
function! s:Stack.new() abort
  let linkedlist = s:LinkedList.new()
  let stack = deepcopy(self)
  let stack.linkedlist = linkedlist
  return stack
endfunction

function! s:Stack.push(item) abort
  call self.linkedlist.add_first(a:item)
endfunction

function! s:Stack.pop() abort
  return self.linkedlist.remove_first()
endfunction

function! s:Stack.empty() abort
  return self.linkedlist.size() is# 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
