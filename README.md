## What is this?
해당 도커 파일은 flask서버에서 aws eks-cli 혹은 kubectl의 명령어를 사용할 수 있게 합니다.

## How to use
```python
@app.route('/common/apis/container', methods = ['GET'] )
def showContainer():    
    try:

        out = subprocess.Popen(['/root/bin/kubectl', 'get', 'pods', '-o', 'wide'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        stdout,stderr = out.communicate()
        print(stdout)
        print(stderr)

        response = {
            "result" : True,
            "string" : str(stdout),
            "errorstring": str(stderr)
        }

        return jsonify(response)

    except Exception as ex:

        response = {
            'result' : False,
            'error': str(ex)
        }

        return jsonify(response)
```