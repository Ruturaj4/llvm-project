// RUN: mlir-translate -mlir-to-llvmir %s | FileCheck %s

module attributes {omp.is_target_device = true} {
  llvm.func @omp_target_region_() {
    %0 = llvm.mlir.constant(20 : i32) : i32
    %1 = llvm.mlir.constant(10 : i32) : i32
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.alloca %2 x i32 {bindc_name = "a", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEa"} : (i64) -> !llvm.ptr<i32>
    %4 = llvm.mlir.constant(1 : i64) : i64
    %5 = llvm.alloca %4 x i32 {bindc_name = "b", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEb"} : (i64) -> !llvm.ptr<i32>
    %6 = llvm.mlir.constant(1 : i64) : i64
    %7 = llvm.alloca %6 x i32 {bindc_name = "c", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEc"} : (i64) -> !llvm.ptr<i32>
    llvm.store %1, %3 : !llvm.ptr<i32>
    llvm.store %0, %5 : !llvm.ptr<i32>
    omp.target map((to -> %3 : !llvm.ptr<i32>), (to -> %5 : !llvm.ptr<i32>), (from -> %7 : !llvm.ptr<i32>)) {
      %8 = llvm.load %3 : !llvm.ptr<i32>
      %9 = llvm.load %5 : !llvm.ptr<i32>
      %10 = llvm.add %8, %9  : i32
      llvm.store %10, %7 : !llvm.ptr<i32>
      omp.terminator
    }
    llvm.return
  }
}

// CHECK:      @[[SRC_LOC:.*]] = private unnamed_addr constant [23 x i8] c"{{[^"]*}}", align 1
// CHECK:      @[[IDENT:.*]] = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @[[SRC_LOC]] }, align 8
// CHECK:      @[[DYNA_ENV:.*]] = weak_odr global %struct.DynamicEnvironmentTy zeroinitializer
// CHECK:      @[[KERNEL_ENV:.*]] = weak_odr constant %struct.KernelEnvironmentTy { %struct.ConfigurationEnvironmentTy { i8 1, i8 1, i8 1 }, ptr @[[IDENT]], ptr @[[DYNA_ENV]] }
// CHECK:      define weak_odr protected void @__omp_offloading_{{[^_]+}}_{{[^_]+}}_omp_target_region__l{{[0-9]+}}(ptr %[[ADDR_A:.*]], ptr %[[ADDR_B:.*]], ptr %[[ADDR_C:.*]])
// CHECK:        %[[INIT:.*]] = call i32 @__kmpc_target_init(ptr @[[KERNEL_ENV]])
// CHECK-NEXT:   %[[CMP:.*]] = icmp eq i32 %3, -1
// CHECK-NEXT:   br i1 %[[CMP]], label %[[LABEL_ENTRY:.*]], label %[[LABEL_EXIT:.*]]
// CHECK:        [[LABEL_ENTRY]]:
// CHECK:        %[[TMP_A:.*]] = alloca ptr, align 8
// CHECK:        store ptr %[[ADDR_A]], ptr %[[TMP_A]], align 8
// CHECK:        %[[PTR_A:.*]] = load ptr, ptr %[[TMP_A]], align 8
// CHECK:        %[[TMP_B:.*]] = alloca ptr, align 8
// CHECK:        store ptr %[[ADDR_B]], ptr %[[TMP_B]], align 8
// CHECK:        %[[PTR_B:.*]] = load ptr, ptr %[[TMP_B]], align 8
// CHECK:        %[[TMP_C:.*]] = alloca ptr, align 8
// CHECK:        store ptr %[[ADDR_C]], ptr %[[TMP_C]], align 8
// CHECK:        %[[PTR_C:.*]] = load ptr, ptr %[[TMP_C]], align 8
// CHECK-NEXT:   br label %[[LABEL_TARGET:.*]]
// CHECK:        [[LABEL_TARGET]]:
// CHECK:        %[[A:.*]] = load i32, ptr %[[PTR_A]], align 4
// CHECK:        %[[B:.*]] = load i32, ptr %[[PTR_B]], align 4
// CHECK:        %[[C:.*]] = add i32 %[[A]], %[[B]]
// CHECK:        store i32 %[[C]], ptr %[[PTR_C]], align 4
// CHECK:        br label %[[LABEL_DEINIT:.*]]
// CHECK:        [[LABEL_DEINIT]]:
// CHECK-NEXT:   call void @__kmpc_target_deinit()
// CHECK-NEXT:   ret void
// CHECK:        [[LABEL_EXIT]]:
// CHECK-NEXT:   ret void
