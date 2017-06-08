import hashlib
import hmac
import base64



def GenerateRestSignature(secret, verb, path, expires, content):
    m = hashlib.md5()
    m.update(content)

    message = bytes(verb+"\n"+path+"\n"+expires+"\n"+m.hexdigest()).encode('utf-8')
    secret = bytes("dce9a4fa6c8a4fba6ede54a1b480c7a4").encode('utf-8')

    return base64.b64encode(hmac.new(secret, message, digestmod=hashlib.sha256).digest())
   