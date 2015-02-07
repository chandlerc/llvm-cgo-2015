; ModuleID = '<stdin>'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: uwtable
define void @_Z1fPfPh(float* %value, i8* %b) #0 {
entry:
  %0 = load float* %value, align 4, !tbaa !1
  %call = call i8* @_ZL6write2fPh(float %0, i8* %b)
  ret void
}

; Function Attrs: uwtable
define internal i8* @_ZL6write2fPh(float %value, i8* %b) #0 {
entry:
  %call = call i32 @_ZL1hf(float %value)
  %call1 = call i8* @_ZL5writejPh(i32 %call, i8* %b)
  ret i8* %call1
}

; Function Attrs: uwtable
define void @_Z1gPfPh(float* %value, i8* %b) #0 {
entry:
  %0 = load float* %value, align 4, !tbaa !1
  %call = call i32 @_ZL1hf(float %0)
  %call1 = call i8* @_ZL5writejPh(i32 %call, i8* %b)
  ret void
}

; Function Attrs: nounwind uwtable
define internal i8* @_ZL5writejPh(i32 %v, i8* %b) #1 {
entry:
  %0 = bitcast i8* %b to i32*
  store i32 %v, i32* %0, align 1
  %add.ptr = getelementptr inbounds i8* %b, i64 4
  ret i8* %add.ptr
}

; Function Attrs: nounwind uwtable
define internal i32 @_ZL1hf(float %value) #1 {
entry:
  %.cast = bitcast float %value to i32
  ret i32 %.cast
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (http://llvm.org/git/clang.git edaf522d3afbfe7458b8234ca25662aec06de149) (http://llvm.org/git/llvm.git 370384a6fd8629a9d8d169823e3937c0d89d794d)"}
!1 = !{!2, !2, i64 0}
!2 = !{!"float", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
