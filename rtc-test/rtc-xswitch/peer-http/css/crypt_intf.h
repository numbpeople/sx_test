typedef int (* callback_encrypt_t)(void * context, const unsigned char * in_buff, unsigned in_len,  unsigned char * out_buf, unsigned * pout_len);
typedef int (* callback_decrypt_t)(void * context, const unsigned char * in_buff, unsigned in_len,  unsigned char * out_buf, unsigned * pout_len);

int register_crypt_callback(void * context, callback_encrypt_t enc, callback_decrypt_t dec);