-- Alert message templates for future ALERT_LOG records.
-- Existing alert history is intentionally preserved unchanged.

CREATE TABLE ALERT_MESSAGE_TEMPLATE (
    TEMPLATE_KEY  VARCHAR2(50 CHAR) PRIMARY KEY,
    TEMPLATE_NAME VARCHAR2(100 CHAR) NOT NULL,
    TEMPLATE_TEXT VARCHAR2(1000 CHAR) NOT NULL,
    UPDATED_BY    VARCHAR2(50 CHAR),
    UPDATED_AT    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

MERGE INTO ALERT_MESSAGE_TEMPLATE target
USING (
    SELECT 'ANIMAL_SHORTAGE' AS TEMPLATE_KEY,
           '개체 미달 경보' AS TEMPLATE_NAME,
           '관제 구역 내 {animalName} 보유 마리수 기준치 미달 현상 지속 감지!' AS TEMPLATE_TEXT
    FROM DUAL
    UNION ALL
    SELECT 'DANGER_OBJECT',
           '위험 이상객체 경보',
           '관제 구역 내 위험 이상객체 [{dangerName}] 실시간 출현! 즉시 대피 요망.'
    FROM DUAL
) source
ON (target.TEMPLATE_KEY = source.TEMPLATE_KEY)
WHEN NOT MATCHED THEN
    INSERT (TEMPLATE_KEY, TEMPLATE_NAME, TEMPLATE_TEXT, UPDATED_BY, UPDATED_AT)
    VALUES (source.TEMPLATE_KEY, source.TEMPLATE_NAME, source.TEMPLATE_TEXT, 'SYSTEM', SYSTIMESTAMP);

COMMIT;
