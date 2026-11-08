SELECT acquisition_channel, COUNT(*) AS users
FROM users
GROUP BY acquisition_channel
ORDER BY users DESC;

SELECT
    u.country,
    ROUND(AVG(IF(t.plan_id='P02', t.amount_usd, NULL)), 2) AS avg_monthly,
    ROUND(AVG(IF(t.plan_id='P03', t.amount_usd, NULL)), 2) AS avg_quarterly,
    ROUND(AVG(IF(t.plan_id='P04', t.amount_usd, NULL)), 2) AS avg_annual,
    ROUND(AVG(IF(t.plan_id='P05', t.amount_usd, NULL)), 2) AS avg_lifetime,
    COUNT(*) AS payments
FROM transactions t
JOIN users u ON u.user_id = t.user_id
WHERE t.transaction_type IN ('first_payment','renewal','upgrade')
GROUP BY u.country
ORDER BY avg_monthly DESC;

SELECT transaction_type,
       COUNT(*)  AS cnt,
       ROUND(SUM(amount_usd), 2) AS sum_amount
FROM transactions
GROUP BY transaction_type
ORDER BY sum_amount DESC;

SELECT
    u.user_id,
    u.signup_date,
    u.country,
    u.platform,
    u.acquisition_channel,
    u.age_group,
    MAX(t.transaction_type = 'trial_start')       AS had_trial,
    MAX(t.transaction_type = 'first_payment')     AS had_payment,
    MAX(t.transaction_type = 'renewal')           AS had_renewal,
    MAX(t.transaction_type = 'upgrade')           AS had_upgrade,
    MAX(t.transaction_type = 'first_payment')
        AND NOT MAX(t.transaction_type='trial_start') AS paid_without_trial,
    ROUND(SUM(CASE WHEN t.transaction_type IN
        ('first_payment','renewal','upgrade','refund')
        THEN t.amount_usd ELSE 0 END), 2)         AS revenue
FROM users u
LEFT JOIN transactions t ON t.user_id = u.user_id
GROUP BY u.user_id;

SELECT
    t.transaction_id,
    t.date,
    t.transaction_type,
    t.plan_id,
    sp.plan_name,
    sp.duration_days,
    u.country,
    u.platform,
    u.acquisition_channel,
    t.campaign,
    t.amount_usd,
    u.user_id
FROM transactions t
JOIN users u              ON u.user_id = t.user_id
JOIN subscription_plans sp ON sp.plan_id = t.plan_id
ORDER BY t.date;

SELECT month, country, channel, spend_usd
FROM marketing_spend
ORDER BY month, country, channel;
