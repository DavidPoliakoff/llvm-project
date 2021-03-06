; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3              | FileCheck %s --check-prefixes=SSE3,SSE3-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,fast-hops    | FileCheck %s --check-prefixes=SSE3,SSE3-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx                | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX1-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,fast-hops      | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX1-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2               | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2,fast-hops     | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vl           | FileCheck %s --check-prefixes=AVX,AVX-SLOW,AVX512-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vl,fast-hops | FileCheck %s --check-prefixes=AVX,AVX-FAST,AVX512-FAST

; 128-bit vectors, 16/32-bit, add/sub

define i32 @extract_extract_v4i32_add_i32(<4 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v4i32_add_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v4i32_add_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v4i32_add_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v4i32_add_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v4i32_add_i32_commute(<4 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v4i32_add_i32_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v4i32_add_i32_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v4i32_add_i32_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v4i32_add_i32_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x01 = add i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v8i16_add_i16(<8 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i16_add_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i16_add_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i16_add_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i16_add_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i16> %x, i32 0
  %x1 = extractelement <8 x i16> %x, i32 1
  %x01 = add i16 %x0, %x1
  ret i16 %x01
}

define i16 @extract_extract_v8i16_add_i16_commute(<8 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i16_add_i16_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i16_add_i16_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i16_add_i16_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i16_add_i16_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i16> %x, i32 0
  %x1 = extractelement <8 x i16> %x, i32 1
  %x01 = add i16 %x1, %x0
  ret i16 %x01
}

define i32 @extract_extract_v4i32_sub_i32(<4 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v4i32_sub_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v4i32_sub_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v4i32_sub_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v4i32_sub_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x01 = sub i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v4i32_sub_i32_commute(<4 x i32> %x) {
; SSE3-LABEL: extract_extract_v4i32_sub_i32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-NEXT:    movd %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4i32_sub_i32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %x01 = sub i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v8i16_sub_i16(<8 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i16_sub_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i16_sub_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i16_sub_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i16_sub_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i16> %x, i32 0
  %x1 = extractelement <8 x i16> %x, i32 1
  %x01 = sub i16 %x0, %x1
  ret i16 %x01
}

define i16 @extract_extract_v8i16_sub_i16_commute(<8 x i16> %x) {
; SSE3-LABEL: extract_extract_v8i16_sub_i16_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8i16_sub_i16_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-NEXT:    retq
  %x0 = extractelement <8 x i16> %x, i32 0
  %x1 = extractelement <8 x i16> %x, i32 1
  %x01 = sub i16 %x1, %x0
  ret i16 %x01
}

; 256-bit vectors, i32/i16, add/sub

define i32 @extract_extract_v8i32_add_i32(<8 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i32_add_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i32_add_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i32_add_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i32_add_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i32> %x, i32 0
  %x1 = extractelement <8 x i32> %x, i32 1
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v8i32_add_i32_commute(<8 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i32_add_i32_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i32_add_i32_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i32_add_i32_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i32_add_i32_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i32> %x, i32 0
  %x1 = extractelement <8 x i32> %x, i32 1
  %x01 = add i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v16i16_add_i16(<16 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i16_add_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i16_add_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i16_add_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i16_add_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i16> %x, i32 0
  %x1 = extractelement <16 x i16> %x, i32 1
  %x01 = add i16 %x0, %x1
  ret i16 %x01
}

define i16 @extract_extract_v16i16_add_i16_commute(<16 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i16_add_i16_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i16_add_i16_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i16_add_i16_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i16_add_i16_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i16> %x, i32 0
  %x1 = extractelement <16 x i16> %x, i32 1
  %x01 = add i16 %x1, %x0
  ret i16 %x01
}

define i32 @extract_extract_v8i32_sub_i32(<8 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v8i32_sub_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v8i32_sub_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v8i32_sub_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v8i32_sub_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <8 x i32> %x, i32 0
  %x1 = extractelement <8 x i32> %x, i32 1
  %x01 = sub i32 %x0, %x1
  ret i32 %x01
}

; Negative test...or get hoppy and negate?

define i32 @extract_extract_v8i32_sub_i32_commute(<8 x i32> %x) {
; SSE3-LABEL: extract_extract_v8i32_sub_i32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-NEXT:    movd %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v8i32_sub_i32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <8 x i32> %x, i32 0
  %x1 = extractelement <8 x i32> %x, i32 1
  %x01 = sub i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v16i16_sub_i16(<16 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i16_sub_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i16_sub_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i16_sub_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i16_sub_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i16> %x, i32 0
  %x1 = extractelement <16 x i16> %x, i32 1
  %x01 = sub i16 %x0, %x1
  ret i16 %x01
}

; Negative test...or get hoppy and negate?

define i16 @extract_extract_v16i16_sub_i16_commute(<16 x i16> %x) {
; SSE3-LABEL: extract_extract_v16i16_sub_i16_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v16i16_sub_i16_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <16 x i16> %x, i32 0
  %x1 = extractelement <16 x i16> %x, i32 1
  %x01 = sub i16 %x1, %x0
  ret i16 %x01
}

; 512-bit vectors, i32/i16, add/sub

define i32 @extract_extract_v16i32_add_i32(<16 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i32_add_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i32_add_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i32_add_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i32_add_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i32> %x, i32 0
  %x1 = extractelement <16 x i32> %x, i32 1
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v16i32_add_i32_commute(<16 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i32_add_i32_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i32_add_i32_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i32_add_i32_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i32_add_i32_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i32> %x, i32 0
  %x1 = extractelement <16 x i32> %x, i32 1
  %x01 = add i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v32i16_add_i16(<32 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v32i16_add_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v32i16_add_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v32i16_add_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v32i16_add_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <32 x i16> %x, i32 0
  %x1 = extractelement <32 x i16> %x, i32 1
  %x01 = add i16 %x0, %x1
  ret i16 %x01
}

define i16 @extract_extract_v32i16_add_i16_commute(<32 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v32i16_add_i16_commute:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v32i16_add_i16_commute:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phaddw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v32i16_add_i16_commute:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v32i16_add_i16_commute:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphaddw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <32 x i16> %x, i32 0
  %x1 = extractelement <32 x i16> %x, i32 1
  %x01 = add i16 %x1, %x0
  ret i16 %x01
}

define i32 @extract_extract_v16i32_sub_i32(<16 x i32> %x) {
; SSE3-SLOW-LABEL: extract_extract_v16i32_sub_i32:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v16i32_sub_i32:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v16i32_sub_i32:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v16i32_sub_i32:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <16 x i32> %x, i32 0
  %x1 = extractelement <16 x i32> %x, i32 1
  %x01 = sub i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v16i32_sub_i32_commute(<16 x i32> %x) {
; SSE3-LABEL: extract_extract_v16i32_sub_i32_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-NEXT:    movd %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v16i32_sub_i32_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <16 x i32> %x, i32 0
  %x1 = extractelement <16 x i32> %x, i32 1
  %x01 = sub i32 %x1, %x0
  ret i32 %x01
}

define i16 @extract_extract_v32i16_sub_i16(<32 x i16> %x) {
; SSE3-SLOW-LABEL: extract_extract_v32i16_sub_i16:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    pextrw $1, %xmm0, %ecx
; SSE3-SLOW-NEXT:    subl %ecx, %eax
; SSE3-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v32i16_sub_i16:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    phsubw %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v32i16_sub_i16:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %eax
; AVX-SLOW-NEXT:    vpextrw $1, %xmm0, %ecx
; AVX-SLOW-NEXT:    subl %ecx, %eax
; AVX-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-SLOW-NEXT:    vzeroupper
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v32i16_sub_i16:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vphsubw %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-FAST-NEXT:    vzeroupper
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <32 x i16> %x, i32 0
  %x1 = extractelement <32 x i16> %x, i32 1
  %x01 = sub i16 %x0, %x1
  ret i16 %x01
}

define i16 @extract_extract_v32i16_sub_i16_commute(<32 x i16> %x) {
; SSE3-LABEL: extract_extract_v32i16_sub_i16_commute:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    pextrw $1, %xmm0, %eax
; SSE3-NEXT:    subl %ecx, %eax
; SSE3-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v32i16_sub_i16_commute:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
  %x0 = extractelement <32 x i16> %x, i32 0
  %x1 = extractelement <32 x i16> %x, i32 1
  %x01 = sub i16 %x1, %x0
  ret i16 %x01
}

; Check output when 1 or both extracts have extra uses.

define i32 @extract_extract_v4i32_add_i32_uses1(<4 x i32> %x, i32* %p) {
; SSE3-SLOW-LABEL: extract_extract_v4i32_add_i32_uses1:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    movd %xmm0, (%rdi)
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v4i32_add_i32_uses1:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    movd %xmm0, (%rdi)
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v4i32_add_i32_uses1:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vmovd %xmm0, (%rdi)
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v4i32_add_i32_uses1:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vmovd %xmm0, (%rdi)
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  store i32 %x0, i32* %p
  %x1 = extractelement <4 x i32> %x, i32 1
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v4i32_add_i32_uses2(<4 x i32> %x, i32* %p) {
; SSE3-SLOW-LABEL: extract_extract_v4i32_add_i32_uses2:
; SSE3-SLOW:       # %bb.0:
; SSE3-SLOW-NEXT:    movd %xmm0, %ecx
; SSE3-SLOW-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-SLOW-NEXT:    movd %xmm0, %eax
; SSE3-SLOW-NEXT:    addl %ecx, %eax
; SSE3-SLOW-NEXT:    movd %xmm0, (%rdi)
; SSE3-SLOW-NEXT:    retq
;
; SSE3-FAST-LABEL: extract_extract_v4i32_add_i32_uses2:
; SSE3-FAST:       # %bb.0:
; SSE3-FAST-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE3-FAST-NEXT:    movd %xmm1, (%rdi)
; SSE3-FAST-NEXT:    phaddd %xmm0, %xmm0
; SSE3-FAST-NEXT:    movd %xmm0, %eax
; SSE3-FAST-NEXT:    retq
;
; AVX-SLOW-LABEL: extract_extract_v4i32_add_i32_uses2:
; AVX-SLOW:       # %bb.0:
; AVX-SLOW-NEXT:    vmovd %xmm0, %ecx
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-SLOW-NEXT:    addl %ecx, %eax
; AVX-SLOW-NEXT:    vpextrd $1, %xmm0, (%rdi)
; AVX-SLOW-NEXT:    retq
;
; AVX-FAST-LABEL: extract_extract_v4i32_add_i32_uses2:
; AVX-FAST:       # %bb.0:
; AVX-FAST-NEXT:    vpextrd $1, %xmm0, (%rdi)
; AVX-FAST-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX-FAST-NEXT:    vmovd %xmm0, %eax
; AVX-FAST-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  store i32 %x1, i32* %p
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

define i32 @extract_extract_v4i32_add_i32_uses3(<4 x i32> %x, i32* %p1, i32* %p2) {
; SSE3-LABEL: extract_extract_v4i32_add_i32_uses3:
; SSE3:       # %bb.0:
; SSE3-NEXT:    movd %xmm0, %ecx
; SSE3-NEXT:    movd %xmm0, (%rdi)
; SSE3-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE3-NEXT:    movd %xmm0, %eax
; SSE3-NEXT:    addl %ecx, %eax
; SSE3-NEXT:    movd %xmm0, (%rsi)
; SSE3-NEXT:    retq
;
; AVX-LABEL: extract_extract_v4i32_add_i32_uses3:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    vmovd %xmm0, (%rdi)
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    addl %ecx, %eax
; AVX-NEXT:    vpextrd $1, %xmm0, (%rsi)
; AVX-NEXT:    retq
  %x0 = extractelement <4 x i32> %x, i32 0
  store i32 %x0, i32* %p1
  %x1 = extractelement <4 x i32> %x, i32 1
  store i32 %x1, i32* %p2
  %x01 = add i32 %x0, %x1
  ret i32 %x01
}

