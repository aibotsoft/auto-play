package main

import (
	"testing"
)

func Test_demo(t *testing.T) {
	tests := []struct {
		name string
		want int
	}{
		{
			name: "need_one",
			want: 1,
		},
	}
	for _, tt := range tests {
		t.Log("helo")
		t.Run(tt.name, func(t *testing.T) {
			if got := demo(); got != tt.want {
				t.Errorf("demo() = %v, want %v", got, tt.want)
			}
		})
	}
}
