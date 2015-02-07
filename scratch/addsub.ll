target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-unknown"

define <4 x float> @test1(<4 x float> %A, <4 x float> %B) {
  %sub = fsub <4 x float> %A, %B
  %add = fadd <4 x float> %A, %B
  %blend = shufflevector <4 x float> %sub, <4 x float> %add, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  ret <4 x float> %blend
}

define <2 x double> @test2(<2 x double> %A, <2 x double> %B) #0 {
  %add = fadd <2 x double> %A, %B
  %sub = fsub <2 x double> %A, %B
  %blend = shufflevector <2 x double> %sub, <2 x double> %add, <2 x i32> <i32 0, i32 3>
  ret <2 x double> %blend
}
