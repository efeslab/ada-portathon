# 1 "80386.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "80386.S"
# 25 "80386.S"
.text




.align 4 ; .globl P_SETP ; P_SETP:
        pushl %ebp
        movl %esp,%ebp
        pushl %ebx
  pushl %ecx
  pushl %edx
        movl 8(%ebp),%eax
        addl $0x1f,%eax
        shrl $5,%eax
        movl %eax,%ebx
        shrl $3,%eax
        movl %eax,prec8
        andl $7,%ebx

        movl $add_ref,%eax
        movl %eax,%ecx
        subl $add_1ref,%eax
        mul %ebx
        subl %eax,%ecx
        movl %ecx,addp
        movl $sub_ref,%ecx
        subl %eax,%ecx
        movl %ecx,subp

        movl $rot_ref,%eax
        movl %eax,%ecx
        subl $rot_1ref,%eax
        mul %ebx
        subl %eax,%ecx
        movl %ecx,rotp

        movl $mul_ref,%eax
        movl %eax,%ecx
        subl $mul_1ref,%eax
        mul %ebx
        subl %eax,%ecx
        movl %ecx,mulp

  popl %edx
  popl %ecx
        popl %ebx
        leave
        ret
# 82 "80386.S"
.align 4 ; .globl P_ADDC ; P_ADDC:
        pushl %ebp
        movl %esp,%ebp
        pushl %ebx
  pushl %ecx
        pushl %esi
        pushl %edi
        movl 12(%ebp),%esi
        movl 8(%ebp),%ebx
        subl %esi,%ebx
        subl $4,%ebx
        cld
        movl 16(%ebp),%eax
        movl prec8,%ecx
        orl %ecx,%ecx
        rcrl $1,%eax
  jz add_units
add_8u:
        lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi)
        loop add_8u
add_units:
        jmp *addp
        lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi) ; lodsl ; adcl %eax,(%ebx,%esi)
add_1ref:
        lodsl ; adcl %eax,(%ebx,%esi)
add_ref:
        rcll $1,%eax
        andl $1,%eax

        popl %edi
        popl %esi
  popl %ecx
        popl %ebx
        leave
        ret
# 125 "80386.S"
.align 4 ; .globl P_SUBB ; P_SUBB:
        pushl %ebp
        movl %esp,%ebp
        pushl %ebx
  pushl %ecx
        pushl %esi
        pushl %edi
        movl 12(%ebp),%esi
        movl 8(%ebp),%ebx
        subl %esi,%ebx
        subl $4,%ebx
        cld
        movl 16(%ebp),%eax
        movl prec8,%ecx
        orl %ecx,%ecx
        rcrl $1,%eax
  jz sub_units
sub_8u:
        lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi)
        loop sub_8u
sub_units:
        jmp *subp
        lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi) ; lodsl ; sbbl %eax,(%ebx,%esi)
sub_ref:
        rcll $1,%eax
        andl $1,%eax

        popl %edi
        popl %esi
  popl %ecx
        popl %ebx
        leave
        ret
# 167 "80386.S"
.align 4 ; .globl P_ROTL ; P_ROTL:
        pushl %ebp
        movl %esp,%ebp
        pushl %ebx
  pushl %ecx
        pushl %esi
        movl 8(%ebp),%ebx
        movl 12(%ebp),%eax
        xorl %esi,%esi
        movl prec8,%ecx
        orl %ecx,%ecx
        rcrl $1,%eax
  jz rot_units
rot_8u:
        rcll $1,(%ebx)
        rcll $1,4(%ebx)
        rcll $1,8(%ebx)
        rcll $1,12(%ebx)
        rcll $1,16(%ebx)
        rcll $1,20(%ebx)
        rcll $1,24(%ebx)
        rcll $1,28(%ebx)
        leal 32(%ebx),%ebx
        loop rot_8u
rot_units:
        jmp *rotp
        rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi ; rcll $1,(%ebx,%esi,4) ; incl %esi
rot_1ref:
        rcll $1,(%ebx,%esi,4) ; incl %esi
rot_ref:
        rcll $1,%eax
        andl $1,%eax

        popl %esi
  popl %ecx
        popl %ebx
        leave
        ret
# 219 "80386.S"
.align 4 ; .globl P_SMULA ; P_SMULA:
        pushl %ebp
        movl %esp,%ebp
        pushl %ebx
  pushl %ecx
  pushl %edx
        pushl %esi
        pushl %edi

        xorl %ebx,%ebx
        movl prec8,%ecx
        movl 8(%ebp),%edi
        movl 12(%ebp),%esi
        movl 16(%ebp),%ebp
        cld
        orl %ecx,%ecx
        jz mul_units
mul_8u:
        lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl
        decl %ecx
        jnz mul_8u
mul_units:
        jmp *mulp
        lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl ; lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl
mul_1ref:
        lodsl ; mull %ebp ; addl %ebx,%eax ; adcl $0,%edx ; addl (%edi),%eax ; adcl $0,%edx ; movl %edx,%ebx ; stosl
mul_ref:
        addl %ebx,(%edi)

        popl %edi
        popl %esi
  popl %edx
  popl %ecx
        popl %ebx
        popl %ebp
        ret


.lcomm _reciph,4
.lcomm _recipl,4
.lcomm _mshift,4

.align 4 ; .globl p_setrecip ; p_setrecip:
  movl 4(%esp),%eax
  movl %eax,_reciph
  movl 8(%esp),%eax
  movl %eax,_recipl
  movl 12(%esp),%eax
  movl %eax,_mshift
  ret


.align 4 ; .globl p_quo_digit ; p_quo_digit:
 pushl %ebp
 pushl %ebx
 pushl %esi
 pushl %edi

 movl 20(%esp),%esi
 movl -8(%esi),%eax
 notl %eax
 mull _reciph
 addl _reciph,%eax
 adcl $0,%edx
 movl %eax,%ebx
 movl %edx,%edi

 movl -4(%esi),%eax
 notl %eax
 mull _recipl
 incl %edx

 movl %edx,%ebp
 andl %edi,%ebp
 andl $1,%ebp

 addl %ebx,%eax
 adcl %edx,%edi
 rcrl $1,%edi

 movl -4(%esi),%eax
 notl %eax
 mull _reciph
 movl %eax,%ebx
 movl %edx,%ecx

 movl (%esi),%eax
 notl %eax
 mull _recipl
 xorl %ebx,%eax
 andl %eax,%ebp
 xorl %ebx,%eax

 addl %ebx,%eax
 adcl %ecx,%edx
 rcrl $1,%edx
 rcrl $1,%eax

 addl %edi,%eax
 adcl $0,%edx
 addl %ebp,%eax
 adcl $0,%edx

 shll $1,%eax
 rcll $1,%edx
 rcll $1,%eax
 rcll $1,%edx
 rcll $1,%eax
 andl $3,%eax
 movl %eax,%ecx
 movl %edx,%ebx

 movl (%esi),%eax
 notl %eax
 mull _reciph
 shll $1,%eax
 rcll $1,%edx
 addl %ebx,%eax
 adcl %ecx,%edx

 movl _mshift,%ecx
 cmpl $32,_mshift
 je L2
# 352 "80386.S"
 shrdl %edx,%eax



 shrl %cl,%edx


 orl %edx,%edx
 je L1
 movl $-1,%eax
 jmp L1
L2:
 xchgl %edx,%eax
L1:
 popl %edi
 popl %esi
 popl %ebx
 popl %ebp
 ret

.lcomm prec8,4
.lcomm addp,4
.lcomm subp,4
.lcomm rotp,4
.lcomm mulp,4
