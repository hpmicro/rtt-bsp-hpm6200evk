# Copyright (c) 2021 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

sdk_inc(.)
sdk_src(hpm_ov5640.c)
sdk_src_ifdef(CONFIG_HPM_CAMERA hpm_camera_ov5640.c)
