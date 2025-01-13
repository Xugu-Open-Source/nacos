/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info   */
/******************************************/
create table config_info
(
    id                 bigint       not null comment '主键ID',
    data_id            varchar(255) not null comment 'data_id',
    group_id           varchar(255),
    content            clob         not null comment 'content',
    md5                varchar(32) comment 'md5',
    gmt_create         datetime     not null default CURRENT_TIMESTAMP comment '创建时间',
    gmt_modified       datetime     not null default CURRENT_TIMESTAMP comment '修改时间',
    src_user           clob comment 'source user',
    src_ip             varchar(50) comment 'source ip',
    app_name           varchar(128),
    tenant_id          varchar(128)          default '' comment '租户字段',
    c_desc             varchar(256),
    c_use              varchar(64),
    effect             varchar(64),
    type               varchar(64),
    c_schema           clob,
    encrypted_data_key clob         not null COMMENT '秘钥'
);
comment
on table config_info is 'config_info';
-- Alter Table Add Identity --
alter table config_info alter column id BIGINT identity(1,1) primary key;

alter table config_info
    add constraint uk_configinfo_datagrouptenant unique (data_id, group_id, tenant_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_aggr   */
/******************************************/
CREATE TABLE config_info_aggr
(
    id           bigint       not null comment '主键ID',
    data_id      varchar(255) not null comment 'data_id',
    group_id     varchar(128) not null comment 'group_id',
    datum_id     varchar(255) not null comment 'datum_id',
    content      clob         not null comment '内容',
    gmt_modified datetime     not null default CURRENT_TIMESTAMP comment '修改时间',
    app_name     varchar(128)          default null comment 'app_name',
    tenant_id    varchar(128)          DEFAULT '' COMMENT '租户字段'
);

alter table config_info_aggr alter column id BIGINT identity(1,1) primary key;

alter table config_info_aggr
    add constraint uk_configinfoaggr_datagrouptenantdatum unique (data_id, group_id, tenant_id, datum_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_beta   */
/******************************************/
CREATE TABLE config_info_beta
(
    id                 bigint       not null comment '主键ID',
    data_id            varchar(255) not null comment 'data_id',
    group_id           varchar(128) not null comment 'group_id',
    app_name           varchar(128)          default null comment 'app_name',
    content            clob         not null comment 'content',
    beta_ips           varchar(1024)         default null comment 'betaIps',
    md5                varchar(32)           DEFAULT NULL COMMENT 'md5',
    gmt_create         datetime     not null default CURRENT_TIMESTAMP comment '创建时间',
    gmt_modified       datetime     not null default CURRENT_TIMESTAMP comment '修改时间',
    src_user           clob COMMENT 'source user',
    src_ip             varchar(50) comment 'source ip',
    tenant_id          varchar(128)          default '' comment '租户字段',
    encrypted_data_key clob         not null COMMENT '秘钥'
);

alter table config_info_beta alter column id BIGINT identity(1,1) primary key;
alter table config_info_beta
    add constraint uk_configinfobeta_datagrouptenant unique (data_id, group_id, tenant_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_tag   */
/******************************************/
CREATE TABLE config_info_tag
(
    id           bigint       not null comment '主键ID',
    data_id      varchar(255) not null comment 'data_id',
    group_id     varchar(128) not null comment 'group_id',
    tenant_id    varchar(128)          default '' comment 'tenant_id',
    tag_id       varchar(128) not null comment 'tag_id',
    app_name     varchar(128) comment 'app_name',
    content      clob         not null comment 'content',
    md5          varchar(32) comment 'md5',
    gmt_create   datetime     not null default CURRENT_TIMESTAMP comment '创建时间',
    gmt_modified datetime     not null default CURRENT_TIMESTAMP comment '修改时间',
    src_user     clob comment 'source user',
    src_ip       varchar(50) comment 'source ip'
);

alter table config_info_tag alter column id BIGINT identity(1,1) primary key;
alter table config_info_tag
    add constraint uk_configinfotag_datagrouptenanttag unique (data_id, group_id, tenant_id, tag_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_tags_relation   */
/******************************************/
CREATE TABLE config_tags_relation
(
    id        bigint       not null comment 'id',
    tag_name  varchar(128) not null comment 'tag_name',
    tag_type  varchar(64) comment 'tag_type',
    data_id   varchar(255) not null comment 'data_id',
    group_id  varchar(128) not null comment 'group_id',
    tenant_id varchar(128) default '' comment 'tenant_id',
    nid       bigint       not null comment '主键ID'
);
alter table config_tags_relation alter column nid BIGINT identity(1,1) primary key;

-- Create Table Index --
create index IDX_TENANT_ID on config_tags_relation (tenant_id) indextype is btree global;
-- Create Table Index --
create unique index uk_configtagrelation_configidtag on config_tags_relation (id, tag_name, tag_type) indextype is btree global;
/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = group_capacity   */
/******************************************/
create table group_capacity
(
    id                bigint       not null comment '主键ID',
    group_id          varchar(128) not null default '' comment 'Group ID，空字符表示整个集群',
    quota             bigint       not null default 0 comment '配额，0表示使用默认值',
    usage             bigint       not null default 0 comment '使用量',
    max_size          bigint       not null default 0 comment '单个配置大小上限，单位为字节，0表示使用默认值',
    max_aggr_count    bigint       not null default 0 comment '聚合子配置最大个数，，0表示使用默认值',
    max_aggr_size     bigint       not null default 0 comment '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
    max_history_count bigint       not null default 0 comment '最大变更历史数量',
    gmt_create        datetime     not null default CURRENT_TIMESTAMP comment '创建时间',
    gmt_modified      datetime     not null default CURRENT_TIMESTAMP comment '修改时间'
);
comment
on table group_capacity is '集群、各Group容量信息表';
-- Alter Table Add Identity --
alter table group_capacity alter column id BIGINT identity(1,1) primary key;

-- Create Table Index --
create unique index UK_IDX_S22111164925885136 on group_capacity (group_id) indextype is btree global;

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = his_config_info   */
/******************************************/
create table his_config_info
(
    id                 bigint       not null,
    nid                bigint       not NULL comment '主键ID',
    data_id            varchar(255) not null,
    group_id           varchar(128) not null,
    app_name           varchar(128) comment 'app_name',
    content            clob         not null,
    md5                varchar(32),
    gmt_create         datetime     not null default CURRENT_TIMESTAMP,
    gmt_modified       datetime     not null default CURRENT_TIMESTAMP,
    src_user           clob,
    src_ip             varchar(50),
    op_type            varchar(10),
    tenant_id          varchar(128)          default '' comment '租户字段',
    encrypted_data_key clob         not null COMMENT '秘钥'
);
comment
on table his_config_info is '多租户改造';
-- Alter Table Add Identity --
alter table his_config_info alter column nid BIGINT identity(1,1) primary key;

create index IDX_DID on his_config_info (data_id) indextype is btree global;
-- Create Table Index --
create index IDX_GMT_CREATE on his_config_info (gmt_create) indextype is btree global;
-- Create Table Index --
create index IDX_GMT_MODIFIED on his_config_info (gmt_modified) indextype is btree global;


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = tenant_capacity   */
/******************************************/
create table tenant_capacity
(
    id                bigint       not null comment '主键ID',
    tenant_id         varchar(128) not null default '' comment 'Tenant ID',
    quota             bigint       not null default 0 comment '配额，0表示使用默认值',
    usage             bigint       not null default 0 comment '使用量',
    max_size          bigint       not null default 0 comment '单个配置大小上限，单位为字节，0表示使用默认值',
    max_aggr_count    bigint       not null default 0 comment '聚合子配置最大个数',
    max_aggr_size     bigint       not null default 0 comment '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
    max_history_count bigint       not null default 0 comment '最大变更历史数量',
    gmt_create        datetime     not null default CURRENT_TIMESTAMP comment '创建时间',
    gmt_modified      datetime     not null default CURRENT_TIMESTAMP comment '修改时间'
);
comment
on table tenant_capacity is '租户容量信息表';
-- Alter Table Add Identity --
alter table tenant_capacity alter column id BIGINT identity(1,1) primary key;

-- Create Table Index --
create unique index UK_IDX_S16456164925885139 on tenant_capacity (tenant_id) indextype is btree global;


create table tenant_info
(
    id            bigint       not null comment '主键ID',
    kp            varchar(128) not null comment 'kp',
    tenant_id     varchar(128) default '' comment 'tenant_id',
    tenant_name   varchar(128) default '' comment 'tenant_name',
    tenant_desc   varchar(256) comment 'tenant_desc',
    create_source varchar(32) comment 'create_source',
    gmt_create    bigint       not null comment '创建时间',
    gmt_modified  bigint       not null comment '修改时间'
);
comment
on table tenant_info is 'tenant_info';
-- Alter Table Add Identity --
alter table tenant_info alter column id BIGINT identity(1,1) primary key;

-- Create Table Index --
create index IDX_TENANT_ID on tenant_info (tenant_id) indextype is btree global;
-- Create Table Index --
create unique index UK_IDX_S26416164925885140 on tenant_info (kp, tenant_id) indextype is btree global;

create table users
(
    username varchar(50)  not null,
    password varchar(500) not null,
    enabled  boolean      not null
);
-- Alter Table Add PrimaryKey Constraint --
alter table users
    add constraint "PRIMARY" primary key (username);

create table roles
(
    username varchar(50) not null,
    role     varchar(50) not null
);

-- Create Table Index --
create unique index UK_IDX_S10142164925885138 on roles (username, role) indextype is btree global;

create table permissions
(
    role     varchar(50)  not null,
    resource varchar(255) not null,
    action   varchar(8)   not null
);

-- Create Table Index --
create unique index UK_IDX_S24855164925885137 on permissions (role, resource, action) indextype is btree global;

INSERT INTO users (username, password, enabled)
VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);

INSERT INTO roles (username, role)
VALUES ('nacos', 'ROLE_ADMIN');
