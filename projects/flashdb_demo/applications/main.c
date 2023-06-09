/*
 * Copyright (c) 2021 hpmicro
 *
 * Change Logs:
 * Date         Author          Notes
 * 2021-08-13   Fan YANG        first version
 *
 */

#include <rtthread.h>
#include <rtdevice.h>
#include "rtt_board.h"
#include <drv_gpio.h>
#include "hpm_romapi.h"
#ifdef PKG_USING_FAL
#include "fal.h"
#endif

#ifdef PKG_USING_FLASHDB
#include "flashdb.h"
#endif


void thread_entry(void *arg);

#ifdef FDB_USING_KVDB
struct fdb_kvdb s_kvdb;
uint32_t boot_count;
static struct fdb_default_kv_node default_kv_table[] = {{"boot_count", &boot_count, sizeof(boot_count)}}; /* int type KV */
extern void kvdb_basic_sample(fdb_kvdb_t kvdb);
#endif

void test_flash(void);

int main(void)
{
#ifdef RT_USING_FAL
    fal_init();
#endif

#ifdef FDB_USING_KVDB
    fdb_err_t fdb_err;
    struct fdb_default_kv default_kv;
    default_kv.kvs = default_kv_table;
    default_kv.num = sizeof(default_kv_table) / sizeof(default_kv_table[0]);

    fdb_err = fdb_kvdb_init(&s_kvdb, "env", "download", &default_kv, NULL);
    if (fdb_err != FDB_NO_ERR) {
        rt_kprintf("FlashDB initialization failed, error_code=%d\n", fdb_err);
        return -fdb_err;
    }
    else
    {
        kvdb_basic_sample(&s_kvdb);
    }

#endif

    rt_thread_t led_thread = rt_thread_create("led_th", thread_entry, NULL, 1024, 1, 10);
    rt_thread_startup(led_thread);

    return 0;
}


void thread_entry(void *arg)
{
	rt_pin_mode(APP_LED0_PIN_NUM, PIN_MODE_OUTPUT);

    while(1){
        rt_pin_write(APP_LED0_PIN_NUM, APP_LED_ON);
        rt_thread_mdelay(200);
        rt_pin_write(APP_LED0_PIN_NUM, APP_LED_OFF);
        rt_thread_mdelay(200);
    }

}
