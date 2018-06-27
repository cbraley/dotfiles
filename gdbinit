# Remove the 'press ENTER to continue' prompts.
set pagination off

# Macros for working with std:: data structures.

# vecsize foo prints the size of the std::vector 'foo'.
define vecsize
  print ($arg0)._M_impl._M_finish - ($arg0)._M_impl._M_start
end
document vecsize
  Print size of specified STL vector
end

# vecelem foo  k prints the kth element the std::vector 'foo'.
define vecelem
  print ($arg0)._M_impl._M_start[($arg1)]
end
document vecelem
  Print specified element of an STL vector
end

# Handy macro to print everything about this frame.
define frameinfo
  info frame
  info args
  info locals
end
document frame
  Print stack frame.
end
