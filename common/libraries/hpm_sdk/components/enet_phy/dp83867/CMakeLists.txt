# Copyright (c) 2021-2024 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

sdk_compile_definitions(-D__USE_DP83867=1)

sdk_inc(.)
sdk_inc(../)
sdk_src(hpm_dp83867.c)
