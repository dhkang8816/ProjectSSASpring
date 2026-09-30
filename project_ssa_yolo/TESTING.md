# Python test guide

Run the tests with the project virtual environment:

```powershell
& 'C:\project_team3\build\envs\ssa310\python.exe' -m pytest tests -q -p no:cacheprovider
```

The test suite mocks subprocess, HTTP and Flask state. It does not open COM6,
run YOLO inference, send Discord notifications or require an ESP32 board.

`requirements-test.txt` installs `requirements.txt` first and then adds pytest.
