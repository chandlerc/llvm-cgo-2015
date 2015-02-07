target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @f(i32 %a, i1 %c1, i1 %c2, i32* %ptr) {
entry:
  %v1 = add i32 %a, 1
  %v2 = add i32 %a, 2
  %v3 = add i32 %a, 3
  %v4 = add i32 %a, 4
  br i1 %c1, label %then1, label %merge

then1:
  %gep1 = getelementptr i32* %ptr, i32 %v1
  store i32 0, i32* %gep1
  br label %merge

merge:
  %gep2 = getelementptr i32* %ptr, i32 %v2
  store i32 0, i32* %gep2
  br i1 %c2, label %then2, label %exit

then2:
  %gep3 = getelementptr i32* %ptr, i32 %v3
  store i32 0, i32* %gep3
  %gep4 = getelementptr i32* %ptr, i32 %v4
  store i32 0, i32* %gep4
  br label %exit

exit:
  %gep5 = getelementptr i32* %ptr, i32 %v4
  store i32 0, i32* %gep5
  ret void
}
