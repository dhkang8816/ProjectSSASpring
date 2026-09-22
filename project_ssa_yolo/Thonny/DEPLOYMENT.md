# ESP32 MicroPython deployment

The Flask service does not use `mpremote run` to install a program.  It sends
short, serialized `mpremote ... resume exec "import main; ..."` commands through
the existing `buzzer_helper` queue.  The board therefore needs this directory's
`main.py` saved as **`/main.py` on the ESP32 filesystem**.

MicroPython automatically runs `/boot.py` and then `/main.py` after reset, so a
separate command-listener process and a custom `boot.py` are not required.  Do
not import `main` from `boot.py`: that can initialize the GPIO/PWM objects
twice on some firmware builds.

From `project_ssa_yolo`, after confirming the board's COM port and making a
backup, an operator may deploy manually:

```powershell
python -m mpremote connect COM6 fs cp :main.py main.py.backup
python -m mpremote connect COM6 fs cp Thonny/main.py :main.py
python -m mpremote connect COM6 reset
```

The deployed `main.py` includes the existing animal, danger, and collision
melodies, plus `play_startup_melody()`.  Battery telemetry shares the existing
`read_sensor_status()` request.  The Flask `SSA_BATTERY_*` settings are applied
inside that existing request; confirm the voltage divider and ADC pin before
changing them on a real board.
