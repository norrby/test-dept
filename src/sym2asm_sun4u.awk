BEGIN { num_functions = 0 }
/ U / { functions[$NF]; num_functions = num_functions + 1 }
END {
  print    "	.section	\".text\""
  for (fun in functions) {
     proxy = fun "_test_dept_proxy"
     print ""
     print "	.global	" proxy
     print "	.type	" proxy ", #object"
     print "	.align	16"
     print proxy ":"
     proxy_ptr = proxy "_ptr"
     print "	set	" proxy "_ptr, %l0"
     print "	ld	[%l0], %l1"
     print "	jmp	%l1"
     print "	nop"
     print "	.size	" proxy ", .-" proxy
  }
  print    ""
  print    "	.section	\".data\""
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print "	.global " proxy_ptr
     print "	.type	" proxy_ptr ", #object"
     print "	.align	16"
     print "	.size	" proxy_ptr ", 8"
     print proxy_ptr ":"
     print "	.long	" fun
     print "	.long	" fun
     print ""
  }
  print    "	.align	16"
  print    "	.global	test_dept_proxy_ptrs"
  print    "	.type	test_dept_proxy_ptrs, #object"
  print    "	.size	test_dept_proxy_ptrs, " num_functions * 4 + 4
  print    "test_dept_proxy_ptrs:"
  for (fun in functions) {
     proxy_ptr = fun "_test_dept_proxy_ptr"
     print "	.long	" proxy_ptr
  }
  print    "	.long	0"
}
