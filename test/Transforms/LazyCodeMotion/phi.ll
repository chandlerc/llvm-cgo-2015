target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @f(i32 %a, i1 %c1, i1 %c2, i32* %ptr) {
entry:
  %v1 = add i32 %a, 1
  %v2 = add i32 %a, 2
  br i1 %c1, label %then, label %merge

then:
  %gep1 = getelementptr i32* %ptr, i32 %v1
  store i32 0, i32* %gep1
  br label %merge

merge:
  %phi1 = phi i32 [ %v1, %entry ], [ %v2, %then1 ]
  %phi2 = phi i32 [ %v2, %entry ], [ %v1, %then1 ]
  %gep2 = getelementptr i32* %ptr, i32 %phi1
  store i32 0, i32* %gep2
  %gep3 = getelementptr i32* %ptr, i32 %phi2
  store i32 0, i32* %gep2
  ret void
}
