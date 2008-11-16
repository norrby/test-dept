/ U / { functions[$NF] }
END {
  print    "	.text"
  for (fun in functions) {
     proxy = fun "_test_dept_proxy"
     proxy_ptr = proxy "_ptr"
     print ".globl " proxy
     print proxy ":"
     print "	movq	" proxy_ptr "(%rip), %r11"
     print "	jmp	*%r11"
  }
  print    ""
  print    "	.data"
  print    "	.align 16"
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print ".globl " proxy_ptr
     print proxy_ptr ":"
     print "	.quad	" fun
     print "	.quad	" fun
  }
  print    ".globl test_dept_proxy_ptrs"
  print    "	.data"
  print    "	.align 8"
  print    "test_dept_proxy_ptrs:"
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print "	.quad	" proxy_ptr
  }
  print    "	.quad	0"
}
