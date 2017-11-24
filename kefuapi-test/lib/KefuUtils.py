import hashlib
import hmac
import base64



def GenerateRestSignature(secret, path, content,expires='-1',verb='POST'):
    m = hashlib.md5()
    m.update(content)

    msg = bytes(verb+"\n"+path+"\n"+expires+"\n"+m.hexdigest()).encode('utf-8')
    s = bytes(secret).encode('utf-8')

    return base64.b64encode(hmac.new(s, msg, digestmod=hashlib.sha256).digest())
   