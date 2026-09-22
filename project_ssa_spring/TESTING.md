# Spring test guide

Run Spring unit tests from this directory after Maven is available:

```powershell
mvn test
```

The diagnostics tests mock the datasource, environment lookup and HTTP client.
They do not connect to Oracle, Flask, ESP32, Discord, Kakao, Open-Meteo or NOAA.

Manual diagnostics smoke test:

1. Log in with an account that has `ROLE_ADMIN`.
2. Open `/admin/diagnostics`.
3. Confirm that the status table is populated by `GET /admin/diagnostics/all`.
4. Confirm the page causes no buzzer sound, Discord message, camera startup or detection action.
