; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN:  llc -amdgpu-scalarize-global-loads=false  -march=amdgcn -verify-machineinstrs -enable-unsafe-fp-math < %s | FileCheck -check-prefixes=SI %s
; RUN:  llc -amdgpu-scalarize-global-loads=false  -march=amdgcn -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs -enable-unsafe-fp-math < %s | FileCheck -check-prefixes=VI %s

define amdgpu_kernel void @fptosi_f16_to_i16(
; SI-LABEL: fptosi_f16_to_i16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_f16_to_i16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_i16_f16_e32 v0, v0
; VI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %r.val = fptosi half %a.val to i16
  store i16 %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fptosi_f16_to_i32(
; SI-LABEL: fptosi_f16_to_i32:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_f16_to_i32:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; VI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %r.val = fptosi half %a.val to i32
  store i32 %r.val, ptr addrspace(1) %r
  ret void
}

; Need to make sure we promote f16 to f32 when converting f16 to i64. Existing
; test checks code generated for 'i64 = fp_to_sint f32'.

define amdgpu_kernel void @fptosi_f16_to_i64(
; SI-LABEL: fptosi_f16_to_i64:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_f16_to_i64:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; VI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; VI-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %r.val = fptosi half %a.val to i64
  store i64 %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fptosi_v2f16_to_v2i16(
; SI-LABEL: fptosi_v2f16_to_v2i16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v1, v1
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_v2f16_to_v2i16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_i16_f16_e32 v1, v0
; VI-NEXT:    v_cvt_i16_f16_sdwa v0, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1
; VI-NEXT:    v_or_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load <2 x half>, ptr addrspace(1) %a
  %r.val = fptosi <2 x half> %a.val to <2 x i16>
  store <2 x i16> %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fptosi_v2f16_to_v2i32(
; SI-LABEL: fptosi_v2f16_to_v2i32:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v1, v1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_v2f16_to_v2i32:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_f32_f16_e32 v1, v0
; VI-NEXT:    v_cvt_f32_f16_sdwa v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; VI-NEXT:    v_cvt_i32_f32_e32 v0, v1
; VI-NEXT:    v_cvt_i32_f32_e32 v1, v2
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load <2 x half>, ptr addrspace(1) %a
  %r.val = fptosi <2 x half> %a.val to <2 x i32>
  store <2 x i32> %r.val, ptr addrspace(1) %r
  ret void
}

; Need to make sure we promote f16 to f32 when converting f16 to i64. Existing
; test checks code generated for 'i64 = fp_to_sint f32'.

define amdgpu_kernel void @fptosi_v2f16_to_v2i64(
; SI-LABEL: fptosi_v2f16_to_v2i64:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v2, v1
; SI-NEXT:    v_cvt_i32_f32_e32 v0, v0
; SI-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; SI-NEXT:    v_cvt_i32_f32_e32 v2, v2
; SI-NEXT:    v_ashrrev_i32_e32 v3, 31, v2
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_v2f16_to_v2i64:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_cvt_f32_f16_e32 v1, v0
; VI-NEXT:    v_cvt_f32_f16_sdwa v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; VI-NEXT:    v_cvt_i32_f32_e32 v0, v1
; VI-NEXT:    v_cvt_i32_f32_e32 v2, v2
; VI-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; VI-NEXT:    v_ashrrev_i32_e32 v3, 31, v2
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load <2 x half>, ptr addrspace(1) %a
  %r.val = fptosi <2 x half> %a.val to <2 x i64>
  store <2 x i64> %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fptosi_f16_to_i1(ptr addrspace(1) %out, half %in) {
; SI-LABEL: fptosi_f16_to_i1:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, s4
; SI-NEXT:    v_cmp_eq_f32_e32 vcc, -1.0, v0
; SI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; SI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fptosi_f16_to_i1:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dword s4, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cmp_eq_f16_e64 s[4:5], 0xbc00, s4
; VI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; VI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
entry:
  %conv = fptosi half %in to i1
  store i1 %conv, ptr addrspace(1) %out
  ret void
}
