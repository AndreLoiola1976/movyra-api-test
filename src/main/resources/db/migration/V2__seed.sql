-- 02_seed.sql
-- Idempotent seeds for MVP: platform admin, demo tenant, catalog + i18n,
-- suggestions + i18n, and initial tenant activation (optional).

-- PLATFORM ADMIN (placeholder auth_subject for now)
insert into app.users (id, auth_subject, email, full_name, is_platform_admin)
values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'local-admin-sub', 'andre@movyra.ai', 'Andre Loiola', true)
on conflict (email) do update
    set is_platform_admin = true,
        full_name = excluded.full_name;

-- DEMO TENANT
insert into app.tenants (id, slug, name, timezone, billing_status, is_active)
values ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'demo-barbershop', 'Demo Barbershop', 'America/New_York', 'trial', true)
on conflict (slug) do nothing;

-- MEMBERSHIP: YOU AS OWNER OF DEMO
insert into app.user_tenants (tenant_id, user_id, role)
values ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'tenant_owner')
on conflict (tenant_id, user_id) do nothing;

-- =========================
-- SERVICE CATALOG (12 services)
-- =========================

-- 1) Classic Haircut
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000001', 'HAIRCUT_CLASSIC', 30, 3000, 'haircut')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000001','en','Classic Haircut','Standard men’s haircut'),
    ('10000000-0000-0000-0000-000000000001','pt','Corte Clássico','Corte masculino padrão'),
    ('10000000-0000-0000-0000-000000000001','es','Corte Clásico','Corte masculino estándar')
on conflict (service_id, lang) do nothing;

-- 2) Skin Fade
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000002', 'HAIRCUT_SKIN_FADE', 45, 4000, 'haircut')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000002','en','Skin Fade','Fade haircut with skin finish'),
    ('10000000-0000-0000-0000-000000000002','pt','Degradê Navalhado','Degradê com acabamento na pele'),
    ('10000000-0000-0000-0000-000000000002','es','Degradado a Cero','Degradado con acabado a piel')
on conflict (service_id, lang) do nothing;

-- 3) Beard Trim
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000003', 'BEARD_TRIM', 20, 2000, 'beard')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000003','en','Beard Trim','Beard shaping and trim'),
    ('10000000-0000-0000-0000-000000000003','pt','Barba','Modelagem e acabamento da barba'),
    ('10000000-0000-0000-0000-000000000003','es','Barba','Perfilado y recorte de barba')
on conflict (service_id, lang) do nothing;

-- 4) Haircut + Beard
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000004', 'COMBO_HAIRCUT_BEARD', 60, 5500, 'combo')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000004','en','Haircut + Beard','Combo service: haircut and beard'),
    ('10000000-0000-0000-0000-000000000004','pt','Corte + Barba','Serviço combinado: corte e barba'),
    ('10000000-0000-0000-0000-000000000004','es','Corte + Barba','Servicio combinado: corte y barba')
on conflict (service_id, lang) do nothing;

-- 5) Line Up
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000005', 'LINE_UP', 15, 1500, 'beard')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000005','en','Line Up','Edge up / shape up'),
    ('10000000-0000-0000-0000-000000000005','pt','Pezinho','Acabamento / contorno'),
    ('10000000-0000-0000-0000-000000000005','es','Perfilado','Contorno / line up')
on conflict (service_id, lang) do nothing;

-- 6) Kids Haircut
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000006', 'HAIRCUT_KIDS', 30, 2500, 'haircut')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000006','en','Kids Haircut','Haircut for kids'),
    ('10000000-0000-0000-0000-000000000006','pt','Corte Infantil','Corte para crianças'),
    ('10000000-0000-0000-0000-000000000006','es','Corte Infantil','Corte para niños')
on conflict (service_id, lang) do nothing;

-- 7) Eyebrows
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000007', 'EYEBROWS', 10, 1200, 'extras')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000007','en','Eyebrows','Eyebrow cleanup'),
    ('10000000-0000-0000-0000-000000000007','pt','Sobrancelha','Acabamento de sobrancelha'),
    ('10000000-0000-0000-0000-000000000007','es','Cejas','Arreglo de cejas')
on conflict (service_id, lang) do nothing;

-- 8) Wash + Style
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000008', 'WASH_STYLE', 20, 2000, 'extras')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000008','en','Wash + Style','Shampoo and basic styling'),
    ('10000000-0000-0000-0000-000000000008','pt','Lavar + Finalizar','Lavagem e finalização básica'),
    ('10000000-0000-0000-0000-000000000008','es','Lavar + Peinar','Lavado y peinado básico')
on conflict (service_id, lang) do nothing;

-- 9) Hot Towel
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000009', 'HOT_TOWEL', 10, 1000, 'extras')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000009','en','Hot Towel','Hot towel treatment'),
    ('10000000-0000-0000-0000-000000000009','pt','Toalha Quente','Tratamento com toalha quente'),
    ('10000000-0000-0000-0000-000000000009','es','Toalla Caliente','Tratamiento con toalla caliente')
on conflict (service_id, lang) do nothing;

-- 10) Razor Shave
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000010', 'SHAVE_RAZOR', 30, 3000, 'beard')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000010','en','Razor Shave','Clean shave with razor'),
    ('10000000-0000-0000-0000-000000000010','pt','Barbear Navalha','Barba feita na navalha'),
    ('10000000-0000-0000-0000-000000000010','es','Afeitado a Navaja','Afeitado con navaja')
on conflict (service_id, lang) do nothing;

-- 11) Hair Design
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000011', 'HAIR_DESIGN', 20, 2500, 'extras')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000011','en','Hair Design','Hair design / lines'),
    ('10000000-0000-0000-0000-000000000011','pt','Risco / Design','Desenho no cabelo'),
    ('10000000-0000-0000-0000-000000000011','es','Diseño','Diseño / líneas en el cabello')
on conflict (service_id, lang) do nothing;

-- 12) Consultation
insert into app.service_catalog (id, code, default_duration_minutes, default_price_cents, category)
values ('10000000-0000-0000-0000-000000000012', 'CONSULTATION', 10, 0, 'extras')
on conflict (code) do nothing;

insert into app.service_catalog_i18n (service_id, lang, name, description)
values
    ('10000000-0000-0000-0000-000000000012','en','Consultation','Quick consultation'),
    ('10000000-0000-0000-0000-000000000012','pt','Consulta','Consulta rápida'),
    ('10000000-0000-0000-0000-000000000012','es','Consulta','Consulta rápida')
on conflict (service_id, lang) do nothing;

-- =========================
-- SUGGESTIONS (all 12 recommended)
-- =========================
insert into app.service_suggestions (service_id, is_recommended, sort_order, score)
values
    ('10000000-0000-0000-0000-000000000001', true, 10, 80),
    ('10000000-0000-0000-0000-000000000002', true, 20, 85),
    ('10000000-0000-0000-0000-000000000003', true, 30, 70),
    ('10000000-0000-0000-0000-000000000004', true, 40, 75),
    ('10000000-0000-0000-0000-000000000005', true, 50, 55),
    ('10000000-0000-0000-0000-000000000006', true, 60, 45),
    ('10000000-0000-0000-0000-000000000007', true, 70, 35),
    ('10000000-0000-0000-0000-000000000008', true, 80, 40),
    ('10000000-0000-0000-0000-000000000009', true, 90, 30),
    ('10000000-0000-0000-0000-000000000010', true, 100, 50),
    ('10000000-0000-0000-0000-000000000011', true, 110, 25),
    ('10000000-0000-0000-0000-000000000012', true, 120, 10)
on conflict (service_id) do update
    set is_recommended = excluded.is_recommended,
        sort_order = excluded.sort_order,
        score = excluded.score;

-- Suggestions i18n (simple, scalable later)
-- For speed: set all 12 with generic headlines, and keep richer reasons for top ones.
insert into app.service_suggestions_i18n (service_id, lang, headline, reason)
values
-- Generic for all services (EN)
('10000000-0000-0000-0000-000000000001','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000002','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000003','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000004','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000005','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000006','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000007','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000008','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000009','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000010','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000011','en','Recommended','Commonly offered by barbershops'),
('10000000-0000-0000-0000-000000000012','en','Recommended','Commonly offered by barbershops'),

-- PT
('10000000-0000-0000-0000-000000000001','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000002','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000003','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000004','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000005','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000006','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000007','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000008','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000009','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000010','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000011','pt','Recomendado','Serviço comum em barbearias'),
('10000000-0000-0000-0000-000000000012','pt','Recomendado','Serviço comum em barbearias'),

-- ES
('10000000-0000-0000-0000-000000000001','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000002','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000003','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000004','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000005','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000006','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000007','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000008','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000009','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000010','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000011','es','Recomendado','Servicio común en barberías'),
('10000000-0000-0000-0000-000000000012','es','Recomendado','Servicio común en barberías')
on conflict (service_id, lang) do update
    set headline = excluded.headline,
        reason = excluded.reason;

-- =========================
-- OPTIONAL: Activate a couple services for demo tenant (for immediate UI tests)
-- =========================
insert into app.tenant_services (tenant_id, service_id, price_cents, duration_minutes, is_active)
values
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','10000000-0000-0000-0000-000000000001', 3000, 30, true),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','10000000-0000-0000-0000-000000000003', 2000, 20, true)
on conflict (tenant_id, service_id) do nothing;
