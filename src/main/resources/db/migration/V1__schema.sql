create schema if not exists app;

-- UUID helper
create extension if not exists pgcrypto;

-- =========================
-- TENANTS (barbearias/salões)
-- =========================
create table if not exists app.tenants (
                                           id uuid primary key default gen_random_uuid(),
                                           slug text not null unique,
                                           name text not null,

    -- contato para página/branding (você disse pra manter simples)
                                           phone text,
                                           address_line1 text,
                                           address_line2 text,
                                           city text,
                                           state text,
                                           zip text,
                                           country char(2) not null default 'US',
                                           timezone text not null default 'America/New_York',

    -- Billing placeholders (simples; sem tabelas extras por agora)
                                           billing_email text,
                                           billing_name text,
                                           billing_status text not null default 'trial'
                                               check (billing_status in ('trial','active','past_due','cancelled')),

                                           is_active boolean not null default true,
                                           created_at timestamptz not null default now()
);

-- =========================
-- USERS (usuários do sistema)
-- Não guardar senha aqui.
-- auth_subject = "sub" do provedor (Supabase/Clerk/etc.)
-- =========================
create table if not exists app.users (
                                         id uuid primary key default gen_random_uuid(),
                                         auth_subject text not null unique,
                                         email text not null unique,
                                         full_name text,
                                         is_platform_admin boolean not null default false,
                                         is_active boolean not null default true,
                                         created_at timestamptz not null default now()
);

-- =========================
-- USER ↔ TENANT (roles)
-- =========================
create table if not exists app.user_tenants (
                                                tenant_id uuid not null references app.tenants(id) on delete cascade,
                                                user_id uuid not null references app.users(id) on delete cascade,
                                                role text not null check (role in ('tenant_owner','tenant_manager','tenant_staff')),
                                                created_at timestamptz not null default now(),
                                                primary key (tenant_id, user_id)
);

create index if not exists idx_user_tenants_user_id on app.user_tenants(user_id);
create index if not exists idx_user_tenants_tenant_id on app.user_tenants(tenant_id);

-- =========================
-- Global service catalog (templates)
-- =========================
create table if not exists app.service_catalog (
                                                   id uuid primary key,
                                                   code text not null unique,
                                                   default_duration_minutes int not null,
                                                   default_price_cents int not null,
                                                   category text not null,
                                                   is_active boolean not null default true,
                                                   created_at timestamptz not null default now()
);

create table if not exists app.service_catalog_i18n (
                                                        service_id uuid not null references app.service_catalog(id) on delete cascade,
                                                        lang char(2) not null check (lang in ('en','pt','es')),
                                                        name text not null,
                                                        description text,
                                                        primary key (service_id, lang)
);

create index if not exists idx_service_catalog_category on app.service_catalog(category);

-- =========================
-- Suggestions (para onboarding / IA sugestiva)
-- =========================
create table if not exists app.service_suggestions (
                                                       service_id uuid primary key references app.service_catalog(id) on delete cascade,
                                                       is_recommended boolean not null default true,
                                                       sort_order int not null default 100,
                                                       score int not null default 0,
                                                       created_at timestamptz not null default now()
);

create index if not exists idx_service_suggestions_order
    on app.service_suggestions (is_recommended, sort_order);

create table if not exists app.service_suggestions_i18n (
                                                            service_id uuid not null references app.service_suggestions(service_id) on delete cascade,
                                                            lang char(2) not null check (lang in ('en','pt','es')),
                                                            headline text not null,
                                                            reason text,
                                                            primary key (service_id, lang)
);

-- =========================
-- TENANT SERVICE ACTIVATION / OVERRIDES
-- (ativar serviços do catálogo para cada barbearia e permitir override de preço/duração)
-- =========================
create table if not exists app.tenant_services (
                                                   tenant_id uuid not null references app.tenants(id) on delete cascade,
                                                   service_id uuid not null references app.service_catalog(id) on delete restrict,
                                                   price_cents int,
                                                   duration_minutes int,
                                                   is_active boolean not null default true,
                                                   created_at timestamptz not null default now(),
                                                   primary key (tenant_id, service_id)
);

create index if not exists idx_tenant_services_tenant
    on app.tenant_services (tenant_id);

create index if not exists idx_tenant_services_service
    on app.tenant_services (service_id);

-- =========================
-- (MVP) BARBERS (tenant-scoped)
-- =========================
create table if not exists app.barbers (
                                           id uuid primary key default gen_random_uuid(),
                                           tenant_id uuid not null references app.tenants(id) on delete cascade,
                                           display_name text not null,
                                           phone text,
                                           is_active boolean not null default true,
                                           created_at timestamptz not null default now()
);

create index if not exists idx_barbers_tenant on app.barbers(tenant_id);

-- =========================
-- (MVP) CUSTOMERS (tenant-scoped)
-- =========================
create table if not exists app.customers (
                                             id uuid primary key default gen_random_uuid(),
                                             tenant_id uuid not null references app.tenants(id) on delete cascade,
                                             full_name text not null,
                                             phone text,
                                             email text,
                                             created_at timestamptz not null default now(),
                                             unique (tenant_id, phone)
);

create index if not exists idx_customers_tenant on app.customers(tenant_id);

-- =========================
-- (MVP) APPOINTMENTS (tenant-scoped)
-- =========================
create table if not exists app.appointments (
                                                id uuid primary key default gen_random_uuid(),
                                                tenant_id uuid not null references app.tenants(id) on delete cascade,

                                                customer_id uuid references app.customers(id) on delete set null,
                                                barber_id uuid references app.barbers(id) on delete set null,
                                                service_id uuid references app.service_catalog(id) on delete restrict,

                                                start_at timestamptz not null,
                                                end_at timestamptz not null,
                                                status text not null check (status in ('requested','confirmed','cancelled','completed','no_show')),

                                                price_cents int,
                                                notes text,

                                                created_by_user_id uuid references app.users(id) on delete set null,
                                                created_at timestamptz not null default now()
);

create index if not exists idx_appt_tenant_start on app.appointments(tenant_id, start_at);
create index if not exists idx_appt_tenant_status on app.appointments(tenant_id, status);
