; ModuleID = '../scratch/instcombine_bug.cpp'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: uwtable
define void @_Z1fPfPh(float* %value, i8* %b) #0 {
entry:
  %value.addr = alloca float*, align 8
  %b.addr = alloca i8*, align 8
  store float* %value, float** %value.addr, align 8, !tbaa !1
  store i8* %b, i8** %b.addr, align 8, !tbaa !1
  %0 = load float** %value.addr, align 8, !tbaa !1
  %arrayidx = getelementptr inbounds float* %0, i64 0
  %1 = load float* %arrayidx, align 4, !tbaa !5
  %2 = load i8** %b.addr, align 8, !tbaa !1
  %call = call i8* @_ZL6write2fPh(float %1, i8* %2)
  ret void
}

; Function Attrs: uwtable
define internal i8* @_ZL6write2fPh(float %value, i8* %b) #0 {
entry:
  %value.addr = alloca float, align 4
  %b.addr = alloca i8*, align 8
  store float %value, float* %value.addr, align 4, !tbaa !5
  store i8* %b, i8** %b.addr, align 8, !tbaa !1
  %0 = load float* %value.addr, align 4, !tbaa !5
  %call = call i32 @_ZL1hf(float %0)
  %1 = load i8** %b.addr, align 8, !tbaa !1
  %call1 = call i8* @_ZL5writejPh(i32 %call, i8* %1)
  ret i8* %call1
}

; Function Attrs: uwtable
define void @_Z1gPfPh(float* %value, i8* %b) #0 {
entry:
  %value.addr = alloca float*, align 8
  %b.addr = alloca i8*, align 8
  store float* %value, float** %value.addr, align 8, !tbaa !1
  store i8* %b, i8** %b.addr, align 8, !tbaa !1
  %0 = load float** %value.addr, align 8, !tbaa !1
  %arrayidx = getelementptr inbounds float* %0, i64 0
  %1 = load float* %arrayidx, align 4, !tbaa !5
  %call = call i32 @_ZL1hf(float %1)
  %2 = load i8** %b.addr, align 8, !tbaa !1
  %call1 = call i8* @_ZL5writejPh(i32 %call, i8* %2)
  ret void
}

; Function Attrs: nounwind uwtable
define internal i8* @_ZL5writejPh(i32 %v, i8* %b) #1 {
entry:
  %v.addr = alloca i32, align 4
  %b.addr = alloca i8*, align 8
  store i32 %v, i32* %v.addr, align 4, !tbaa !7
  store i8* %b, i8** %b.addr, align 8, !tbaa !1
  %0 = load i8** %b.addr, align 8, !tbaa !1
  %1 = bitcast i32* %v.addr to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* %1, i64 4, i32 1, i1 false)
  %2 = load i8** %b.addr, align 8, !tbaa !1
  %add.ptr = getelementptr inbounds i8* %2, i64 4
  ret i8* %add.ptr
}

; Function Attrs: nounwind uwtable
define internal i32 @_ZL1hf(float %value) #1 {
entry:
  %value.addr = alloca float, align 4
  %i = alloca i32, align 4
  store float %value, float* %value.addr, align 4, !tbaa !5
  %0 = bitcast i32* %i to i8*
  %1 = bitcast float* %value.addr to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* %1, i64 4, i32 4, i1 false)
  %2 = load i32* %i, align 4, !tbaa !7
  ret i32 %2
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (http://llvm.org/git/clang.git edaf522d3afbfe7458b8234ca25662aec06de149) (http://llvm.org/git/llvm.git 370384a6fd8629a9d8d169823e3937c0d89d794d)"}
!1 = !{!2, !2, i64 0}
!2 = !{!"any pointer", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"float", !3, i64 0}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !3, i64 0}
