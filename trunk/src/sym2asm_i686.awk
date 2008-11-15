/ U / { functions[$NF] }
END {
  print    "	.text"
  for (fun in functions) {
     proxy = fun "_test_dept_proxy"
     proxy_ptr = proxy "_ptr"
     print ".globl " proxy
     print proxy ":"
     print "	movl	" proxy_ptr ", %ecx"
     print "	jmp	*%ecx"
  }
  print    ""
  print    "	.data"
  print    "	.align 4"
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print ".globl " proxy_ptr
     print proxy_ptr ":"
     print "	.long	" fun
     print "	.long	" fun
  }
  print    ".globl test_dept_proxy_ptrs"
  print    "	.data"
  print    "	.align 4"
  print    "test_dept_proxy_ptrs:"
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print "	.long	" proxy_ptr
  }
  print    "	.long	0"
}
