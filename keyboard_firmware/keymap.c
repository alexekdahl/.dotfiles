#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
	[0] = LAYOUT(KC_ESC, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0, KC_MINS, KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_LT, KC_ESC, KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_NUHS, KC_AMPR, KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, KC_MUTE, TG(3), KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_NO, KC_LGUI, KC_LALT, KC_LCTL, MO(1), KC_SPC, KC_ENT, KC_BSPC, KC_RSFT, KC_NO, KC_NO),
	[1] = LAYOUT(LALT(KC_RBRC), KC_AT, KC_UNDS, LSFT(KC_EQL), RSA(KC_7), KC_MPLY, LCTL(KC_LEFT), LCTL(KC_RGHT), KC_NO, KC_NO, KC_NO, LGUI(KC_Q), LGUI(KC_W), RALT(KC_7), KC_CIRC, KC_ASTR, KC_LPRN, KC_PPLS, KC_P7, KC_P8, KC_P9, KC_NO, KC_NO, KC_LBRC, RALT(KC_2), RALT(KC_4), KC_GT, RSA(KC_8), RSA(KC_9), KC_PIPE, KC_P4, KC_P5, KC_P6, KC_NO, KC_SCLN, KC_QUOT, LSFT(KC_GRV), KC_GRV, KC_PERC, RALT(KC_8), RALT(KC_9), KC_RPRN, KC_NO, KC_NO, KC_P1, KC_P2, KC_P3, KC_UP, KC_RGHT, KC_NO, KC_NO, KC_NO, KC_NO, KC_TRNS, KC_NO, LGUI(KC_SPC), KC_P0, LGUI(KC_N), KC_LEFT, KC_DOWN),
	[2] = LAYOUT(KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_MPLY, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO),
	[3] = LAYOUT(KC_ESC, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0, KC_MINS, KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_LBRC, KC_ESC, KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_SCLN, KC_QUOT, KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, KC_NO, KC_TRNS, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_RSFT, KC_LGUI, KC_LALT, KC_LCTL, MO(1), KC_SPC, KC_ENT, KC_BSPC, KC_LSFT, KC_NO, KC_NO)
};


#ifdef OLED_ENABLE

static void render_logo(void) {
    static const char PROGMEM qmk_logo[] = {
        0x80,0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88,0x89,0x8a,0x8b,0x8c,0x8d,0x8e,0x8f,0x90,0x91,0x92,0x93,0x94,
        0xa0,0xa1,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,0xa8,0xa9,0xaa,0xab,0xac,0xad,0xae,0xaf,0xb0,0xb1,0xb2,0xb3,0xb4,
        0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xcb,0xcc,0xcd,0xce,0xcf,0xd0,0xd1,0xd2,0xd3,0xd4,0
    };

    oled_write_P(qmk_logo, false);
}

bool oled_task_user(void) {
    render_logo();
    return false;
}
#endif

#ifdef ENCODER_ENABLE

bool encoder_update_user(uint8_t index, bool clockwise) {
    if (index == 0) {
        if (clockwise) {
            tap_code(KC_VOLU);
        } else {
            tap_code(KC_VOLD);
        }
    } else if (index == 1) {
        if (clockwise) {
            tap_code(KC_PGDN);
        } else {
            tap_code(KC_PGUP);
        }
    }
    return true;
}

#endif


























