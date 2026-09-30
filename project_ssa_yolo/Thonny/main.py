from machine import ADC, Pin, PWM
import dht
import time


# =========================================================
# 공통 설정
# =========================================================

BUZZER_PIN = 6
DHT_PIN = 18
LIGHT_PIN = 8
ULTRASONIC_TRIGGER_PIN = 17
ULTRASONIC_ECHO_PIN = 1

# 부저 음량 통일
BUZZER_DUTY = 10

# 초음파 유효 측정 범위
MIN_DISTANCE_CM = 2
MAX_DISTANCE_CM = 50

# 충돌 단계 기준
DANGER_DISTANCE_CM = 10
WARNING_DISTANCE_CM = 20
CAUTION_DISTANCE_CM = 30

# Battery ADC configuration for the board's actual GPIO2 divider:
# VBAT -- 40.2k -- GPIO2 -- 10k -- GND
# Restoring GPIO2 to VBAT therefore requires (40.2 + 10) / 10 = 5.02.
# Keep the vendor-validated ADC formula intact:
# raw / 4095 * 1.0 * 5.02 * 0.96.
# No attenuation is configured here; the board reference program uses only
# ADC(Pin(2)) and the divided battery input remains below the ADC's 1.1V range.
BATTERY_ENABLED = True
BATTERY_ADC_PIN = 2
BATTERY_ADC_REFERENCE_VOLTAGE = 1.0
BATTERY_DIVIDER_RATIO = 5.02
BATTERY_CALIBRATION = 0.96
BATTERY_MIN_VOLTAGE = 3.0
BATTERY_MAX_VOLTAGE = 4.25
BATTERY_SAMPLE_COUNT = 8
BATTERY_LOW_PERCENT = 25
BATTERY_CRITICAL_PERCENT = 10


# =========================================================
# 부저 초기화
# =========================================================

melody_buzzer = PWM(Pin(BUZZER_PIN, Pin.OUT))
melody_buzzer.duty(0)


# =========================================================
# 환경 센서 초기화
# =========================================================

dht_sensor = dht.DHT11(Pin(DHT_PIN))

light_sensor = ADC(Pin(LIGHT_PIN))

try:
    light_sensor.atten(ADC.ATTN_11DB)
except AttributeError:
    pass


# Battery sensing deliberately shares the single read_sensor_status() command
# with the other board sensors.  A failed/absent ADC is represented as
# DISCONNECTED rather than a misleading 0% battery level.
battery_sensor = None


def _initialize_battery_sensor():
    global battery_sensor
    battery_sensor = None
    if not BATTERY_ENABLED:
        return
    try:
        battery_sensor = ADC(Pin(BATTERY_ADC_PIN))
    except Exception:
        battery_sensor = None


def configure_battery(enabled=None, adc_pin=None, adc_reference_voltage=None,
        divider_ratio=None, calibration=None, min_voltage=None,
        max_voltage=None, sample_count=None, low_percent=None,
        critical_percent=None):
    """Apply PC runtime settings without opening another board connection."""
    global BATTERY_ENABLED, BATTERY_ADC_PIN, BATTERY_ADC_REFERENCE_VOLTAGE
    global BATTERY_DIVIDER_RATIO, BATTERY_CALIBRATION, BATTERY_MIN_VOLTAGE
    global BATTERY_MAX_VOLTAGE, BATTERY_SAMPLE_COUNT, BATTERY_LOW_PERCENT
    global BATTERY_CRITICAL_PERCENT

    previous = (
        BATTERY_ENABLED, BATTERY_ADC_PIN, BATTERY_ADC_REFERENCE_VOLTAGE,
        BATTERY_DIVIDER_RATIO, BATTERY_CALIBRATION, BATTERY_MIN_VOLTAGE,
        BATTERY_MAX_VOLTAGE, BATTERY_SAMPLE_COUNT, BATTERY_LOW_PERCENT,
        BATTERY_CRITICAL_PERCENT
    )
    if enabled is not None:
        BATTERY_ENABLED = bool(enabled)
    if adc_pin is not None:
        BATTERY_ADC_PIN = int(adc_pin)
    if adc_reference_voltage is not None and adc_reference_voltage > 0:
        BATTERY_ADC_REFERENCE_VOLTAGE = float(adc_reference_voltage)
    if divider_ratio is not None and divider_ratio > 0:
        BATTERY_DIVIDER_RATIO = float(divider_ratio)
    if calibration is not None and calibration > 0:
        BATTERY_CALIBRATION = float(calibration)
    if min_voltage is not None and max_voltage is not None and max_voltage > min_voltage:
        BATTERY_MIN_VOLTAGE = float(min_voltage)
        BATTERY_MAX_VOLTAGE = float(max_voltage)
    if sample_count is not None and sample_count > 0:
        BATTERY_SAMPLE_COUNT = int(sample_count)
    if low_percent is not None and low_percent >= 0:
        BATTERY_LOW_PERCENT = float(low_percent)
    if critical_percent is not None and critical_percent >= 0:
        BATTERY_CRITICAL_PERCENT = float(critical_percent)

    current = (
        BATTERY_ENABLED, BATTERY_ADC_PIN, BATTERY_ADC_REFERENCE_VOLTAGE,
        BATTERY_DIVIDER_RATIO, BATTERY_CALIBRATION, BATTERY_MIN_VOLTAGE,
        BATTERY_MAX_VOLTAGE, BATTERY_SAMPLE_COUNT, BATTERY_LOW_PERCENT,
        BATTERY_CRITICAL_PERCENT
    )
    if current != previous:
        _initialize_battery_sensor()


_initialize_battery_sensor()


# =========================================================
# 초음파 센서 초기화
# =========================================================

ultrasonic_trigger = Pin(
    ULTRASONIC_TRIGGER_PIN,
    Pin.OUT
)

ultrasonic_echo = Pin(
    ULTRASONIC_ECHO_PIN,
    Pin.IN
)

ultrasonic_trigger.value(0)


# =========================================================
# 공통 부저 함수
# =========================================================

def init_buzzer():
    try:
        melody_buzzer.freq(500)
        melody_buzzer.duty(BUZZER_DUTY)
        time.sleep_ms(30)
        melody_buzzer.duty(0)
        return True
    except Exception:
        melody_buzzer.duty(0)
        return False

def _beep(frequency, duration_ms):
    """
    지정한 주파수와 시간으로 부저를 한 번 울린다.
    모든 알람은 BUZZER_DUTY 값을 공통으로 사용한다.
    """

    try:
        melody_buzzer.freq(frequency)
        melody_buzzer.duty(BUZZER_DUTY)

        time.sleep_ms(duration_ms)

    finally:
        melody_buzzer.duty(0)


def stop_buzzer():
    """
    부저 강제 정지
    """
    melody_buzzer.duty(0)


# =========================================================
# 동물 감지 알람
# =========================================================

def play_animal_alert():
    """
    동물 감지:
    낮고 차분한 2회 알림
    """

    for _ in range(2):
        _beep(330, 200)
        time.sleep_ms(180)

    stop_buzzer()


# =========================================================
# 위험 객체 감지 알람
# =========================================================

def play_danger_alert():
    """
    위험 객체 감지:
    빠르고 높은 5회 경고음
    """

    for _ in range(5):
        _beep(650, 100)
        time.sleep_ms(70)

    stop_buzzer()


def play_startup_melody():
    """Short do-mi-sol confirmation after the Flask optional workers are ready."""
    for frequency in (262, 330, 392):
        _beep(frequency, 90)
        time.sleep_ms(55)
    stop_buzzer()


def play_shutdown_melody():
    """Short sol-mi-do confirmation before the Flask service exits."""
    for frequency in (392, 330, 262):
        _beep(frequency, 90)
        time.sleep_ms(55)
    stop_buzzer()


# =========================================================
# 충돌 경고 알람
# =========================================================

def play_collision_alert(level):
    """
    거리 단계별 충돌 경고음

    CAUTION:
        느린 단음

    WARNING:
        빠른 2회 경고

    DANGER:
        매우 빠른 4회 경고
    """

    if level == "CAUTION":

        _beep(520, 100)

    elif level == "WARNING":

        for _ in range(2):
            _beep(650, 90)
            time.sleep_ms(80)

    elif level == "DANGER":

        for _ in range(4):
            _beep(820, 70)
            time.sleep_ms(40)

    else:
        stop_buzzer()


# =========================================================
# 온도 / 습도
# =========================================================

def read_temperature_humidity():
    """
    DHT11 온도 / 습도 측정

    실패 시:
    temperature = 0
    humidity = 0
    """

    try:
        dht_sensor.measure()

        temperature = dht_sensor.temperature()
        humidity = dht_sensor.humidity()

        return temperature, humidity

    except Exception:
        return 0, 0


# =========================================================
# 조도
# =========================================================

def read_light():
    """
    ADC 조도값 측정

    현재 값은 실제 lux가 아니라 ADC RAW 값이다.

    실패 시:
    0
    """

    try:
        return light_sensor.read()

    except Exception:
        return 0


# =========================================================
# Battery telemetry
# =========================================================

def _battery_disconnected():
    return {
        "available": False,
        "voltage": None,
        "percent": None,
        "status": "DISCONNECTED"
    }


def _battery_status_for_percent(percent):
    if percent <= BATTERY_CRITICAL_PERCENT:
        return "CRITICAL"
    if percent <= BATTERY_LOW_PERCENT:
        return "LOW"
    return "NORMAL"


def read_battery_status():
    """Return filtered Li-ion voltage and percent, or DISCONNECTED safely."""
    if not BATTERY_ENABLED or battery_sensor is None:
        return _battery_disconnected()

    try:
        total = 0
        sample_count = max(1, BATTERY_SAMPLE_COUNT)
        for _ in range(sample_count):
            total += battery_sensor.read()

        raw_value = total / sample_count
        # A battery supply cannot legitimately be 0V.  Treat this as an open
        # input or unsupported ADC rather than persisting/displaying 0%.
        if raw_value <= 0:
            return _battery_disconnected()

        adc_ratio = raw_value / 4095
        adc_voltage = adc_ratio * BATTERY_ADC_REFERENCE_VOLTAGE
        battery_voltage = (
            adc_voltage
            * BATTERY_DIVIDER_RATIO
            * BATTERY_CALIBRATION
        )
        if battery_voltage <= 0 or BATTERY_MAX_VOLTAGE <= BATTERY_MIN_VOLTAGE:
            return _battery_disconnected()

        percent = (battery_voltage - BATTERY_MIN_VOLTAGE) / (
            BATTERY_MAX_VOLTAGE - BATTERY_MIN_VOLTAGE
        ) * 100
        percent = max(0, min(100, percent))

        return {
            "available": True,
            # "voltage" is always the final restored VBAT value, not GPIO2.
            "voltage": round(battery_voltage, 2),
            "percent": round(percent, 1),
            "status": _battery_status_for_percent(percent),
            # These diagnostics are retained only in the ESP32 payload.  The
            # Flask public API keeps its established response shape.
            "raw": round(raw_value, 1),
            "adcVoltage": round(adc_voltage, 3)
        }
    except Exception:
        return _battery_disconnected()


# =========================================================
# 초음파 거리
# =========================================================

def read_distance():
    """
    초음파 거리 측정

    정상 범위:
    2cm ~ 50cm

    범위를 벗어나거나 timeout / 오류 발생 시:
    0 반환
    """

    try:

        # Trigger 초기화
        ultrasonic_trigger.value(0)
        time.sleep_us(2)

        # Trigger Pulse
        ultrasonic_trigger.value(1)
        time.sleep_us(10)
        ultrasonic_trigger.value(0)

        # -------------------------------------------------
        # Echo HIGH 대기
        # -------------------------------------------------

        started = time.ticks_us()

        while ultrasonic_echo.value() == 0:

            if time.ticks_diff(
                time.ticks_us(),
                started
            ) > 30000:

                return 0

        pulse_start = time.ticks_us()

        # -------------------------------------------------
        # Echo LOW 대기
        # -------------------------------------------------

        while ultrasonic_echo.value() == 1:

            if time.ticks_diff(
                time.ticks_us(),
                pulse_start
            ) > 30000:

                return 0

        pulse_end = time.ticks_us()

        duration = time.ticks_diff(
            pulse_end,
            pulse_start
        )

        # cm 변환
        distance = round(
            (duration * 0.0343) / 2,
            1
        )

        # 유효 범위 확인
        if MIN_DISTANCE_CM <= distance <= MAX_DISTANCE_CM:
            return distance

        return 0

    except Exception:
        return 0


# =========================================================
# 충돌 단계 계산
# =========================================================

def get_collision_level(distance):
    """
    충돌 거리 단계

    0:
        UNKNOWN

    0 ~ 10cm:
        DANGER

    10 ~ 20cm:
        WARNING

    20 ~ 30cm:
        CAUTION

    30cm 이상:
        SAFE
    """

    if distance is None or distance <= 0:
        return "UNKNOWN"

    if distance < DANGER_DISTANCE_CM:
        return "DANGER"

    if distance < WARNING_DISTANCE_CM:
        return "WARNING"

    if distance < CAUTION_DISTANCE_CM:
        return "CAUTION"

    return "SAFE"


# =========================================================
# 전체 센서 상태 조회
# =========================================================

def read_sensor_status():
    """
    PC에서 mpremote로 호출할 통합 센서 함수

    한 번의 호출로:

    - temperature
    - humidity
    - illumination
    - distance
    - collisionLevel
    - collisionWarning
    - battery

    반환
    """

    temperature, humidity = read_temperature_humidity()

    illumination = read_light()

    distance = read_distance()

    collision_level = get_collision_level(
        distance
    )

    collision_warning = (
        collision_level in (
            "CAUTION",
            "WARNING",
            "DANGER"
        )
    )

    return {
        "temperature": temperature,
        "humidity": humidity,
        "illumination": illumination,
        "distance": distance,
        "collisionLevel": collision_level,
        "collisionWarning": collision_warning,
        "battery": read_battery_status()
    }
