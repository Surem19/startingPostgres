-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/configurationservice/changelog-master.xml
-- Ran at: 9/24/19 11:59 AM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/configurationservice/changelogs/base/changelog.xml::initial tables creation::Service Archetype
CREATE TABLE CONFIGURATION_RECORD (RIPPLENET_CONFIG_KEY VARCHAR(255) NOT NULL, RIPPLENET_CONFIG_VALUE VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, CONSTRAINT CONFIGURATION_RECORD_PKEY PRIMARY KEY (RIPPLENET_CONFIG_KEY));

CREATE TABLE FEE (ID BIGSERIAL NOT NULL, FEE_ID UUID NOT NULL, CURRENCY_CODE CHAR(3) NOT NULL, PARTNER_NAME VARCHAR(255) NOT NULL, ACCOUNT_NAME VARCHAR(255) NOT NULL, LOWER_LIMIT numeric(28, 9) NOT NULL, UPPER_LIMIT numeric(28, 9) NOT NULL, ROLE_TYPE SMALLINT NOT NULL, NODE_TYPE SMALLINT NOT NULL, PAYMENT_TYPE SMALLINT NOT NULL, FEE_VALUE numeric(28, 9) NOT NULL, FEE_TYPE SMALLINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, STATUS SMALLINT DEFAULT 1 NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT FEE_PKEY PRIMARY KEY (ID), UNIQUE (FEE_ID));

COMMENT ON TABLE FEE IS 'Fee Configuration table';

COMMENT ON COLUMN FEE.ID IS 'Database primary key';

COMMENT ON COLUMN FEE.FEE_ID IS 'Universally Unique ID representing the fee publicly across RippleNet';

COMMENT ON COLUMN FEE.CURRENCY_CODE IS '3-character currency code (e.g., USD, XRP, etc)';

COMMENT ON COLUMN FEE.PARTNER_NAME IS 'Ripplenet address of the partner host to which the fee applies';

COMMENT ON COLUMN FEE.ACCOUNT_NAME IS 'Name of the partner account to which the fee applies';

COMMENT ON COLUMN FEE.LOWER_LIMIT IS 'Lower limit of the fee if slab-based';

COMMENT ON COLUMN FEE.UPPER_LIMIT IS 'Upper limit of the fee if slab-based';

COMMENT ON COLUMN FEE.ROLE_TYPE IS 'Role of the partner to which the fee applies (SENDING(0), RECEIVING(1), INSTITUTION_SENDING(2), INSTITUTION_RECEIVING(3))';

COMMENT ON COLUMN FEE.NODE_TYPE IS 'xCurrent node type in the context of a multi-hop payment (INITIAL(2), TERMINAL(1), INTERMEDIATE(0))';

COMMENT ON COLUMN FEE.PAYMENT_TYPE IS 'Type of payment to which the fee applies (REGULAR(0), RETURN(1))';

COMMENT ON COLUMN FEE.FEE_VALUE IS 'The fee amount';

COMMENT ON COLUMN FEE.FEE_TYPE IS 'Fee calculation type (PERCENTAGE(0), FLAT-RATE(1))';

COMMENT ON COLUMN FEE.CREATED_DTTM IS 'Time that the fee configuration record was created';

COMMENT ON COLUMN FEE.MODIFIED_DTTM IS 'Time that the fee configuration record was last modified';

COMMENT ON COLUMN FEE.STATUS IS 'Active/non-active status of the fee configuration (1, 0)';

COMMENT ON COLUMN FEE.VERSION IS 'Internal value used by the database to update the fee configuration record';

CREATE TABLE RATE (ID BIGSERIAL NOT NULL, RATE_ID UUID NOT NULL, ORDER_TYPE SMALLINT NOT NULL, RATE_SCALE INTEGER NOT NULL, RATE numeric(28, 9) NOT NULL, BASE_CURRENCY CHAR(3) NOT NULL, COUNTER_CURRENCY CHAR(3) NOT NULL, SOURCE_CURRENCY CHAR(3) NOT NULL, DESTINATION_CURRENCY CHAR(3) NOT NULL, SOURCE_LEDGER VARCHAR(255) NOT NULL, DESTINATION_LEDGER VARCHAR(255) NOT NULL, SOURCE_LEDGER_ACCOUNT VARCHAR(255) NOT NULL, DESTINATION_LEDGER_ACCOUNT VARCHAR(255) NOT NULL, LOWER_LIMIT numeric(28, 9) NOT NULL, UPPER_LIMIT numeric(28, 9) NOT NULL, DISABLED BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, EXPIRES_AT TIMESTAMP WITHOUT TIME ZONE, VERSION SMALLINT NOT NULL, CONSTRAINT RATE_PKEY PRIMARY KEY (ID), UNIQUE (RATE_ID));

COMMENT ON TABLE RATE IS 'Rate configuration table';

COMMENT ON COLUMN RATE.ID IS 'Database primary key';

COMMENT ON COLUMN RATE.RATE_ID IS 'Universally Unique ID representing the exchange rate publicly across RippleNet';

COMMENT ON COLUMN RATE.ORDER_TYPE IS 'Order type of the exchange rate request (BUY, SELL)';

COMMENT ON COLUMN RATE.RATE_SCALE IS 'Number of decimal places to which the exchange rate is calculated';

COMMENT ON COLUMN RATE.RATE IS 'Exchange rate for the specified base and counter currency pair';

COMMENT ON COLUMN RATE.BASE_CURRENCY IS 'Base currency of the currency pair for which the exchange rate is configured';

COMMENT ON COLUMN RATE.COUNTER_CURRENCY IS 'Counter currency of the currency pair for which the exchange rate is configured';

COMMENT ON COLUMN RATE.SOURCE_CURRENCY IS 'Currency type of the exchange rate source, determined by the order type (e.g., base currency if BUY, counter currency if SELL)';

COMMENT ON COLUMN RATE.DESTINATION_CURRENCY IS 'Currency type of the exchange rate destination, determined by the order type (e.g., counter currency if BUY, base currency if SELL)';

COMMENT ON COLUMN RATE.SOURCE_LEDGER IS 'Ledger of the exchange rate source';

COMMENT ON COLUMN RATE.DESTINATION_LEDGER IS 'Ledger of the exchange rate destination';

COMMENT ON COLUMN RATE.SOURCE_LEDGER_ACCOUNT IS 'Account on the source ledger of the exchange rate configuration';

COMMENT ON COLUMN RATE.DESTINATION_LEDGER_ACCOUNT IS 'Account on the destination ledger of the exchange rate configuration';

COMMENT ON COLUMN RATE.LOWER_LIMIT IS 'Lower limit of the exchange rate if slab-based';

COMMENT ON COLUMN RATE.UPPER_LIMIT IS 'Upper limit of the exchange rate if slab-based';

COMMENT ON COLUMN RATE.DISABLED IS 'Active/non-active status of the exchange rate configuration (1, 0)';

COMMENT ON COLUMN RATE.CREATED_DTTM IS 'Time that the exchange rate configuration record was created';

COMMENT ON COLUMN RATE.MODIFIED_DTTM IS 'Time that the exchange rate configuration record was last modified';

COMMENT ON COLUMN RATE.EXPIRES_AT IS 'Time at which the exchange rate configuration record expires';

COMMENT ON COLUMN RATE.VERSION IS 'Internal value used by the database to update the rate configuration record';

ALTER TABLE RATE ADD UNIQUE (DISABLED, SOURCE_CURRENCY, DESTINATION_CURRENCY, SOURCE_LEDGER, DESTINATION_LEDGER, SOURCE_LEDGER_ACCOUNT, DESTINATION_LEDGER_ACCOUNT, LOWER_LIMIT, UPPER_LIMIT);

-- Changeset db/configurationservice/changelogs/base/changelog.xml::initial oracle sequence generators::fees
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/ledgerservice/changelog-master.xml
-- Ran at: 9/24/19 11:59 AM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/ledgerservice/changelogs/base/changelog.xml::create initial tables::xcurrent
CREATE TABLE ACCOUNT (ID BIGSERIAL NOT NULL, ACCOUNT_NAME VARCHAR(255) NOT NULL, BALANCE numeric(28, 9) NOT NULL, MINIMUM_ALLOWED_BALANCE numeric(28, 9) NOT NULL, MAXIMUM_ALLOWED_BALANCE numeric(28, 9) NOT NULL, LOW_LIQUIDITY_THRESHOLD numeric(28, 9), OWNER_MIN_ALLOWED_BALANCE numeric(28, 9), OWNER_MAX_ALLOWED_BALANCE numeric(28, 9), DISABLED BOOLEAN NOT NULL, OWNER VARCHAR(50) NOT NULL, CURRENCY CHAR(3) NOT NULL, ROUNDING_MODE SMALLINT NOT NULL, SCALE SMALLINT NOT NULL, ACCOUNT_TYPE SMALLINT NOT NULL, HOLD_ACCOUNT_NAME VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT ACCOUNT_PKEY PRIMARY KEY (ID), UNIQUE (ACCOUNT_NAME));

COMMENT ON TABLE ACCOUNT IS 'Accounts data table';

COMMENT ON COLUMN ACCOUNT.ID IS 'Database Primary Key';

COMMENT ON COLUMN ACCOUNT.ACCOUNT_NAME IS 'Account name, and unique account identifier, on an xCurrent instance';

COMMENT ON COLUMN ACCOUNT.BALANCE IS 'Balance available on the account';

COMMENT ON COLUMN ACCOUNT.MINIMUM_ALLOWED_BALANCE IS 'Minimum balance allowed on the account, set by ledger owner';

COMMENT ON COLUMN ACCOUNT.MAXIMUM_ALLOWED_BALANCE IS 'Maximum balance allowed on the account, set by ledger owner';

COMMENT ON COLUMN ACCOUNT.LOW_LIQUIDITY_THRESHOLD IS 'Low liquidity threshold for the account';

COMMENT ON COLUMN ACCOUNT.OWNER_MIN_ALLOWED_BALANCE IS 'Minimum balance allowed on the account, set by account owner';

COMMENT ON COLUMN ACCOUNT.OWNER_MAX_ALLOWED_BALANCE IS 'Maximum balance allowed on the account, set by account owner';

COMMENT ON COLUMN ACCOUNT.DISABLED IS 'Status of the account';

COMMENT ON COLUMN ACCOUNT.OWNER IS 'Owner of the account';

COMMENT ON COLUMN ACCOUNT.CURRENCY IS 'Currency associated with the account';

COMMENT ON COLUMN ACCOUNT.ROUNDING_MODE IS 'Rounding mode used to update the account balance (HALF_UP, HALF_DOWN, DOWN)';

COMMENT ON COLUMN ACCOUNT.SCALE IS 'Number of decimal places to which the account balance should be rounded';

COMMENT ON COLUMN ACCOUNT.ACCOUNT_TYPE IS 'Type of account (REGULAR, HOLD)';

COMMENT ON COLUMN ACCOUNT.HOLD_ACCOUNT_NAME IS 'Name of internal account used to temporarily hold funds during a transaction';

COMMENT ON COLUMN ACCOUNT.CREATED_DTTM IS 'Time that the account record was created';

COMMENT ON COLUMN ACCOUNT.MODIFIED_DTTM IS 'Time that the account record was last modified';

COMMENT ON COLUMN ACCOUNT.VERSION IS 'Internal value used by the database to update the account record';

CREATE TABLE BALANCE_CHANGE (ID BIGSERIAL NOT NULL, BALANCE_CHANGE_ID UUID NOT NULL, ACCOUNT_NAME VARCHAR(255) NOT NULL, BALANCE_RESULT numeric(28, 9) NOT NULL, BALANCE_CHANGE numeric(28, 9) NOT NULL, OWNER VARCHAR(50) NOT NULL, TRANSACTION_ID UUID NOT NULL, TRANSACTION_TYPE SMALLINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT BALANCE_CHANGE_PKEY PRIMARY KEY (ID), UNIQUE (BALANCE_CHANGE_ID));

COMMENT ON TABLE BALANCE_CHANGE IS 'Table to store transaction history of accounts';

COMMENT ON COLUMN BALANCE_CHANGE.ID IS 'Database primary key';

COMMENT ON COLUMN BALANCE_CHANGE.BALANCE_CHANGE_ID IS 'Universally Unique ID representing the balance change publically across RippleNet';

COMMENT ON COLUMN BALANCE_CHANGE.ACCOUNT_NAME IS 'Name of the account with the balance change';

COMMENT ON COLUMN BALANCE_CHANGE.BALANCE_RESULT IS 'Balance available after the balance change';

COMMENT ON COLUMN BALANCE_CHANGE.BALANCE_CHANGE IS 'Amount that the balance changed';

COMMENT ON COLUMN BALANCE_CHANGE.OWNER IS 'Owner of the account';

COMMENT ON COLUMN BALANCE_CHANGE.TRANSACTION_ID IS 'Universally Unique ID representing the transaction (PaymentId or TransferId) that caused the balance change';

COMMENT ON COLUMN BALANCE_CHANGE.TRANSACTION_TYPE IS 'Type of transaction (PAYMENT, TRANSFER, EXCHANGE_TRANSFER)';

COMMENT ON COLUMN BALANCE_CHANGE.CREATED_DTTM IS 'Time that the balance change record was created';

COMMENT ON COLUMN BALANCE_CHANGE.MODIFIED_DTTM IS 'Time that the balance change record was last modified';

COMMENT ON COLUMN BALANCE_CHANGE.VERSION IS 'Internal value used by the database to update the balance change record';

-- Changeset db/ledgerservice/changelogs/base/changelog.xml::oracleSequence::ledgerService
-- Changeset db/ledgerservice/changelogs/4.1/changelog.xml::Add rollbacked column to BalanceChange::bsundaravaradan
ALTER TABLE BALANCE_CHANGE ADD ROLLBCK_ST SMALLINT DEFAULT 0 NOT NULL;

COMMENT ON COLUMN BALANCE_CHANGE.ROLLBCK_ST IS 'Rollback status for this balance change';

ALTER TABLE BALANCE_CHANGE ADD RELATED_BALANCE_CHANGE_ID UUID;

COMMENT ON COLUMN BALANCE_CHANGE.RELATED_BALANCE_CHANGE_ID IS 'Balance change related to current record if this is a rollback';

-- Changeset db/ledgerservice/changelogs/4.1/changelog.xml::Add indexes for balance change::bsundaravaradan
CREATE INDEX IDX_TXN_ID ON BALANCE_CHANGE(TRANSACTION_ID);

CREATE INDEX IDX_CREATED_DTTM ON BALANCE_CHANGE(CREATED_DTTM);

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/paymentorchestrationservice/changelog-master.xml
-- Ran at: 9/24/19 11:59 AM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/paymentorchestrationservice/changelogs/base/changelog.xml::create initial tables::bsundaravaradan
CREATE TABLE PAYMENT (ID BIGSERIAL NOT NULL, PAYMENT_ID UUID NOT NULL, PAYMENT_TYPE SMALLINT NOT NULL, RETURNED BOOLEAN NOT NULL, RETURNS_PAYMENT_WITH_ID UUID, RETURNED_BY_PAYMENT_WITH_ID UUID, CONTRACT_HASH VARCHAR(255) NOT NULL, PAYMENT_STATE SMALLINT NOT NULL, QUOTE_ID UUID NOT NULL, EXECUTION_CONDITION VARCHAR(255), CRYPTO_TRANSACTION_ID VARCHAR(255), SENDER_END_TO_END_ID VARCHAR(255), EXPIRES_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, INTERNAL_ID VARCHAR(255), VALIDATOR VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT PAYMENT_PKEY PRIMARY KEY (ID), UNIQUE (PAYMENT_ID));

COMMENT ON TABLE PAYMENT IS 'Payment table';

COMMENT ON COLUMN PAYMENT.ID IS 'Database primary key';

COMMENT ON COLUMN PAYMENT.PAYMENT_ID IS 'Universally Unique ID representing the payment publicly across RippleNet';

COMMENT ON COLUMN PAYMENT.PAYMENT_TYPE IS 'Type of payment (REGULAR, RETURN)';

COMMENT ON COLUMN PAYMENT.RETURNED IS 'Flag that indicates if the return payment is returned';

COMMENT ON COLUMN PAYMENT.RETURNS_PAYMENT_WITH_ID IS 'Universally Unique ID representing the REGULAR payment referenced (and returned) by the RETURN payment';

COMMENT ON COLUMN PAYMENT.RETURNED_BY_PAYMENT_WITH_ID IS 'Universally Unique ID representing the RETURN payment that returned the REGULAR payment';

COMMENT ON COLUMN PAYMENT.CONTRACT_HASH IS 'Hash of the contract object nested in the payment object';

COMMENT ON COLUMN PAYMENT.PAYMENT_STATE IS 'State of the payment in the payment chain (ACCEPTED, LOCKED, PREPARED, EXECUTED, COMPLETED, LOCK_DECLINED, SETTLEMENT_DECLINED, FAILED, RETURNED)';

COMMENT ON COLUMN PAYMENT.QUOTE_ID IS 'Universally Unique ID representing the quote that this payment settles';

COMMENT ON COLUMN PAYMENT.SENDER_END_TO_END_ID IS 'ID set by the sender and persisted on all xCurrent instances that participate in the payment';

COMMENT ON COLUMN PAYMENT.EXPIRES_AT IS 'Time that the payment expires';

COMMENT ON COLUMN PAYMENT.CREATED_AT IS 'Time that the payment object was created by sender application';

COMMENT ON COLUMN PAYMENT.INTERNAL_ID IS 'ID set locally and only persisted on (and visible to) the local xCurrent instance';

COMMENT ON COLUMN PAYMENT.VALIDATOR IS 'RippleNet address of the Validator';

COMMENT ON COLUMN PAYMENT.CREATED_DTTM IS 'Time that the payment record was created';

COMMENT ON COLUMN PAYMENT.MODIFIED_DTTM IS 'Time that the payment record was last modified';

COMMENT ON COLUMN PAYMENT.VERSION IS 'Internal value used by the database to update the payment record';

CREATE TABLE USER_INFO_ENTRY (ID BIGSERIAL NOT NULL, ENTITY_TYPE_ID UUID NOT NULL, STATE VARCHAR(255) NOT NULL, NODE_ADDRESS VARCHAR(255) NOT NULL, JSON OID NOT NULL, ENTITY_TYPE SMALLINT NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT USER_INFO_ENTRY_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE USER_INFO_ENTRY IS 'User info records of payments and transfers';

COMMENT ON COLUMN USER_INFO_ENTRY.ID IS 'Database primary key';

COMMENT ON COLUMN USER_INFO_ENTRY.ENTITY_TYPE_ID IS 'ID of entity that this user info is associated with';

COMMENT ON COLUMN USER_INFO_ENTRY.STATE IS 'State of the payment or transfer when the user info was added';

COMMENT ON COLUMN USER_INFO_ENTRY.NODE_ADDRESS IS 'RippleNet Address of the node that added the user info';

COMMENT ON COLUMN USER_INFO_ENTRY.JSON IS 'User added Json';

COMMENT ON COLUMN USER_INFO_ENTRY.ENTITY_TYPE IS 'Entity type associated with the user info (PAYMENT, TRANSFER, EXCHANGE_TRADE, CRYPTO_TRANSFER)';

COMMENT ON COLUMN USER_INFO_ENTRY.CREATED_AT IS 'Time that the user info entry was created by the application';

COMMENT ON COLUMN USER_INFO_ENTRY.CREATED_DTTM IS 'Time that the user info entry record was created';

CREATE TABLE RIPPLE_NET_INFO_ENTRY (ID BIGSERIAL NOT NULL, PAYMENT_ID UUID NOT NULL, ENTITY_TYPE VARCHAR(255) NOT NULL, VALUE VARCHAR(255) NOT NULL, NODE_ADDRESS VARCHAR(255) NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT RIPPLE_NET_INFO_ENTRY_PKEY PRIMARY KEY (ID));

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.ID IS 'Database primary key';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.PAYMENT_ID IS 'Universally Unique ID representing the payment publicly across RippleNet';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.ENTITY_TYPE IS 'Entity type (currently only created only in state, SETTLEMENT_DECLINED)';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.VALUE IS 'Contents of the RippleNet info entry';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.NODE_ADDRESS IS 'RippleNet Address of the node that created the RippleNet info entry';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.CREATED_AT IS 'Time that the RippleNet info entry was created by the application';

COMMENT ON COLUMN RIPPLE_NET_INFO_ENTRY.CREATED_DTTM IS 'Time that the RippleNet info entry record was created';

CREATE TABLE TRANSFER (ID BIGSERIAL NOT NULL, TRANSFER_ID UUID NOT NULL, STATE SMALLINT NOT NULL, OWNER_ADDRESS VARCHAR(255), SENDER_ADDRESS VARCHAR(255) NOT NULL, RECEIVER_ADDRESS VARCHAR(255) NOT NULL, AMOUNT numeric(28, 9) NOT NULL, TRANSFER_TYPE SMALLINT NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, INTERNAL_ID VARCHAR(255), END_TO_END_ID VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT TRANSFER_PKEY PRIMARY KEY (ID), UNIQUE (TRANSFER_ID));

COMMENT ON TABLE TRANSFER IS 'Transfer records';

COMMENT ON COLUMN TRANSFER.ID IS 'Database primary key';

COMMENT ON COLUMN TRANSFER.TRANSFER_ID IS 'Universally Unique ID representing the transfer publicly across RippleNetD';

COMMENT ON COLUMN TRANSFER.STATE IS 'State of the transfer (EXECUTED, COMPLETED, FAILED)';

COMMENT ON COLUMN TRANSFER.OWNER_ADDRESS IS 'Ripplenet address of the account owner that this transfer is performed on';

COMMENT ON COLUMN TRANSFER.SENDER_ADDRESS IS 'RippleNet address of the node initiating the transfer';

COMMENT ON COLUMN TRANSFER.RECEIVER_ADDRESS IS 'RippleNet Address of the node receiving the transfer';

COMMENT ON COLUMN TRANSFER.AMOUNT IS 'Amount to be transferred';

COMMENT ON COLUMN TRANSFER.TRANSFER_TYPE IS 'Type of the transfer';

COMMENT ON COLUMN TRANSFER.CREATED_AT IS 'Time that the transfer was created by the application';

COMMENT ON COLUMN TRANSFER.INTERNAL_ID IS 'User defined ID set by the user';

COMMENT ON COLUMN TRANSFER.END_TO_END_ID IS 'User defined ID set by the sender and shared across all nodes';

COMMENT ON COLUMN TRANSFER.CREATED_DTTM IS 'Time that the transfer record was created';

COMMENT ON COLUMN TRANSFER.MODIFIED_DTTM IS 'Time that the transfer record was last modified';

COMMENT ON COLUMN TRANSFER.VERSION IS 'Internal value used by the database to update the transfer record';

CREATE TABLE EXCHANGE_TRANSFER (ID BIGSERIAL NOT NULL, EXCHANGE_TRANSFER_ID UUID NOT NULL, STATE SMALLINT NOT NULL, SENDER_ADDRESS VARCHAR(255) NOT NULL, RECEIVER_ADDRESS VARCHAR(255) NOT NULL, ORIGINATOR_ADDRESS VARCHAR(255) NOT NULL, SOURCE_AMOUNT numeric(28, 9) NOT NULL, DESTINATION_AMOUNT numeric(28, 9) NOT NULL, SOURCE_CURRENCY CHAR(3) NOT NULL, DESTINATION_CURRENCY CHAR(3) NOT NULL, EXCHANGE_TRANSFER_TYPE SMALLINT NOT NULL, FX_RATE numeric(28, 9) NOT NULL, BASE_CURRENCY CHAR(3) NOT NULL, COUNTER_CURRENCY CHAR(3) NOT NULL, RATE_TYPE VARCHAR(255) NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, INTERNAL_ID VARCHAR(255), END_TO_END_ID VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT EXCHANGE_TRANSFER_PKEY PRIMARY KEY (ID), UNIQUE (EXCHANGE_TRANSFER_ID));

COMMENT ON TABLE EXCHANGE_TRANSFER IS 'Exchange transfers Records';

COMMENT ON COLUMN EXCHANGE_TRANSFER.ID IS 'Database primary key';

COMMENT ON COLUMN EXCHANGE_TRANSFER.EXCHANGE_TRANSFER_ID IS 'Unique ID of the exchange transfer';

COMMENT ON COLUMN EXCHANGE_TRANSFER.STATE IS 'State of the exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.SENDER_ADDRESS IS 'Sender RippleNet Address of the exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.RECEIVER_ADDRESS IS 'Receiver RippleNet Address of the exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.ORIGINATOR_ADDRESS IS 'RippleNet Address initiating this exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.SOURCE_AMOUNT IS 'Amount to be sent from the source';

COMMENT ON COLUMN EXCHANGE_TRANSFER.DESTINATION_AMOUNT IS 'Amount to be received at the destination';

COMMENT ON COLUMN EXCHANGE_TRANSFER.SOURCE_CURRENCY IS 'Currency of the source account';

COMMENT ON COLUMN EXCHANGE_TRANSFER.DESTINATION_CURRENCY IS 'Currency of the destination account';

COMMENT ON COLUMN EXCHANGE_TRANSFER.EXCHANGE_TRANSFER_TYPE IS 'Denotes if the exchange is Firm or Indicative';

COMMENT ON COLUMN EXCHANGE_TRANSFER.FX_RATE IS 'FX rate applied for this transfer';

COMMENT ON COLUMN EXCHANGE_TRANSFER.BASE_CURRENCY IS 'Base currency for this exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.COUNTER_CURRENCY IS 'Counter currency for this exchange';

COMMENT ON COLUMN EXCHANGE_TRANSFER.RATE_TYPE IS 'Denotes if the rate is Buy or Sell';

COMMENT ON COLUMN EXCHANGE_TRANSFER.CREATED_AT IS 'Time that the exchange transfer was created by the application';

COMMENT ON COLUMN EXCHANGE_TRANSFER.INTERNAL_ID IS 'User defined ID';

COMMENT ON COLUMN EXCHANGE_TRANSFER.END_TO_END_ID IS 'Shared user defined ID set by the sender';

COMMENT ON COLUMN EXCHANGE_TRANSFER.CREATED_DTTM IS 'Time that the exchange transfer record was created';

COMMENT ON COLUMN EXCHANGE_TRANSFER.MODIFIED_DTTM IS 'Time that the exchange transfer record was last modified';

COMMENT ON COLUMN EXCHANGE_TRANSFER.VERSION IS 'Internal value used by the database to update the exchange transfer record';

CREATE TABLE PAYMENT_LABEL (ID BIGSERIAL NOT NULL, PAYMENT BIGINT NOT NULL, PAYMENT_ID UUID NOT NULL, LABEL VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, ACTIVE SMALLINT NOT NULL, CONSTRAINT PAYMENT_LABEL_PKEY PRIMARY KEY (ID), CONSTRAINT FK_PAYMENT FOREIGN KEY (PAYMENT) REFERENCES PAYMENT(ID));

COMMENT ON TABLE PAYMENT_LABEL IS 'Label record attached to a payment';

COMMENT ON COLUMN PAYMENT_LABEL.ID IS 'Database primary key';

COMMENT ON COLUMN PAYMENT_LABEL.PAYMENT IS 'Foreign key from Payment table';

COMMENT ON COLUMN PAYMENT_LABEL.PAYMENT_ID IS 'Universally Unique ID representing the payment associated with the label';

COMMENT ON COLUMN PAYMENT_LABEL.LABEL IS 'Label string';

COMMENT ON COLUMN PAYMENT_LABEL.CREATED_DTTM IS 'Time that the payment label record was created';

COMMENT ON COLUMN PAYMENT_LABEL.MODIFIED_DTTM IS 'Time that the payment label record was last modified';

COMMENT ON COLUMN PAYMENT_LABEL.ACTIVE IS 'Denotes if this label should be shown';

CREATE TABLE TRANSFER_LABEL (ID BIGSERIAL NOT NULL, TRANSFER BIGINT NOT NULL, TRANSFER_ID UUID NOT NULL, LABEL VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, ACTIVE SMALLINT NOT NULL, CONSTRAINT TRANSFER_LABEL_PKEY PRIMARY KEY (ID), CONSTRAINT FK_TRANSFER FOREIGN KEY (TRANSFER) REFERENCES TRANSFER(ID));

COMMENT ON TABLE TRANSFER_LABEL IS 'Label records of Transfers';

COMMENT ON COLUMN TRANSFER_LABEL.ID IS 'Database primark key';

COMMENT ON COLUMN TRANSFER_LABEL.TRANSFER IS 'Foreign key from Transfers table';

COMMENT ON COLUMN TRANSFER_LABEL.TRANSFER_ID IS 'Transfer ID this label belongs to';

COMMENT ON COLUMN TRANSFER_LABEL.LABEL IS 'Label string';

COMMENT ON COLUMN TRANSFER_LABEL.CREATED_DTTM IS 'Time that the transfer label record was created';

COMMENT ON COLUMN TRANSFER_LABEL.MODIFIED_DTTM IS 'Time that the transfer label record was last modified';

COMMENT ON COLUMN TRANSFER_LABEL.ACTIVE IS 'Denotes if this label should be shown';

CREATE INDEX IDX_ACTIVE_LABEL_PAYMENT ON PAYMENT_LABEL(ACTIVE, LABEL, PAYMENT);

CREATE INDEX IDX_PAYMENT_LABEL_PAYMENT ON PAYMENT_LABEL(PAYMENT);

CREATE INDEX IDX_ACTIVE_LABEL_TRANSFER ON TRANSFER_LABEL(ACTIVE, LABEL, TRANSFER);

CREATE INDEX IDX_USER_INFO_ENTITY_TYPE ON USER_INFO_ENTRY(ENTITY_TYPE_ID, ENTITY_TYPE);

-- Changeset db/paymentorchestrationservice/changelogs/base/changelog.xml::payment-nodes::jjanardhanan
CREATE TABLE PAYMENT_NODE_INFO (ID BIGSERIAL NOT NULL, PAYMENT_ID UUID NOT NULL, PATH_ORDER SMALLINT NOT NULL, NODE_ADDRESS VARCHAR(255) NOT NULL, STATE SMALLINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT PAYMENT_NODE_INFO_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE PAYMENT_NODE_INFO IS 'Records denoting the ordered list of RippleNet Addresses participating in a payment';

COMMENT ON COLUMN PAYMENT_NODE_INFO.ID IS 'Database primary key';

COMMENT ON COLUMN PAYMENT_NODE_INFO.PAYMENT_ID IS 'Universally Unique ID representing the payment publicly across RippleNet';

COMMENT ON COLUMN PAYMENT_NODE_INFO.PATH_ORDER IS 'Denotes the order of this record in the payment path';

COMMENT ON COLUMN PAYMENT_NODE_INFO.NODE_ADDRESS IS 'RippleNet address of the node participating in the payment';

COMMENT ON COLUMN PAYMENT_NODE_INFO.STATE IS 'Payment state at this node';

COMMENT ON COLUMN PAYMENT_NODE_INFO.CREATED_DTTM IS 'Time that the payment node info record was created';

COMMENT ON COLUMN PAYMENT_NODE_INFO.MODIFIED_DTTM IS 'Time that the payment node info record was last modified';

CREATE TABLE PAYMENT_EXPIRY (ID BIGSERIAL NOT NULL, PAYMENT_TTL_MS BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT PAYMENT_EXPIRY_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE PAYMENT_EXPIRY IS 'Stores the configured payment expiry duration';

COMMENT ON COLUMN PAYMENT_EXPIRY.ID IS 'Database primary key';

COMMENT ON COLUMN PAYMENT_EXPIRY.PAYMENT_TTL_MS IS 'Payment expiry in milliseconds';

COMMENT ON COLUMN PAYMENT_EXPIRY.CREATED_DTTM IS 'Time that the payment expiry record was created';

COMMENT ON COLUMN PAYMENT_EXPIRY.MODIFIED_DTTM IS 'Time that the payment expiry record was last modified';

ALTER TABLE PAYMENT_NODE_INFO ADD CONSTRAINT PAYMENT_ID_NODE_ADDRESS_UK UNIQUE (PAYMENT_ID, NODE_ADDRESS);

-- Changeset db/paymentorchestrationservice/changelogs/base/changelog.xml::oracle_sequence::payment_orchestration
-- Changeset db/paymentorchestrationservice/changelogs/base/changelog.xml::update-payment-table::nbondugula
ALTER TABLE PAYMENT ADD connector_role SMALLINT;

-- Changeset db/paymentorchestrationservice/changelogs/base/changelog-execution-results.xml::execution-results::chris
CREATE TABLE RN_EXECUTION_RESULT (ID BIGSERIAL NOT NULL, SENDING_ADDRESS VARCHAR(255) NOT NULL, RECEIVING_ADDRESS VARCHAR(255) NOT NULL, TRANSFER_CURRENCY CHAR(3), SENDING_CURRENCY CHAR(3), RECEIVING_CURRENCY CHAR(3), SENDER_AMOUNT numeric(14, 4) NOT NULL, RECEIVER_AMOUNT numeric(14, 4) NOT NULL, SENDING_FEE numeric(14, 4) NOT NULL, RECEIVING_FEE numeric(14, 4) NOT NULL, FX_RATE numeric(14, 10) NOT NULL, BASE_CURRENCY CHAR(3), COUNTER_CURRENCY CHAR(3), RATE_TYPE VARCHAR(255), RESULT_ORDER SMALLINT NOT NULL, PAYMENT_ID UUID NOT NULL, EXECUTION_TIMESTAMP_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, EXECUTION_RESULT_TYPE VARCHAR(255) NOT NULL, EXECUTION_RESULT_ID UUID, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT RN_EXECUTION_RESULT_PKEY PRIMARY KEY (ID), CONSTRAINT FK_PAYMENT_EXEC_RESULT FOREIGN KEY (PAYMENT_ID) REFERENCES PAYMENT(PAYMENT_ID));

COMMENT ON COLUMN RN_EXECUTION_RESULT.ID IS 'Database primary key';

COMMENT ON COLUMN RN_EXECUTION_RESULT.SENDING_ADDRESS IS 'RippleNet Address of the sender of transfer or exchange';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RECEIVING_ADDRESS IS 'RippleNet Address of the receiver of transfer or exchange';

COMMENT ON COLUMN RN_EXECUTION_RESULT.SENDING_CURRENCY IS 'Currency of the sending amount';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RECEIVING_CURRENCY IS 'Currency of the receiving amount';

COMMENT ON COLUMN RN_EXECUTION_RESULT.SENDER_AMOUNT IS 'Amount of the transfer or exchange sent in the sender currency';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RECEIVER_AMOUNT IS 'Amount of the transfer or exchange received in the receiver currency';

COMMENT ON COLUMN RN_EXECUTION_RESULT.SENDING_FEE IS 'Sending fee applied to sender amount';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RECEIVING_FEE IS 'Receiving fee applied to receiver amount';

COMMENT ON COLUMN RN_EXECUTION_RESULT.FX_RATE IS 'Exchange rate applied to the transfer or exchange';

COMMENT ON COLUMN RN_EXECUTION_RESULT.BASE_CURRENCY IS 'Base currency of the exchange rate';

COMMENT ON COLUMN RN_EXECUTION_RESULT.COUNTER_CURRENCY IS 'Counter currency of the exchange rate';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RATE_TYPE IS 'The exchange rate order type (BUY, SELL)';

COMMENT ON COLUMN RN_EXECUTION_RESULT.RESULT_ORDER IS 'Number of this result in an ordered series';

COMMENT ON COLUMN RN_EXECUTION_RESULT.PAYMENT_ID IS 'Universally Unique ID representing the payment associated with the result';

COMMENT ON COLUMN RN_EXECUTION_RESULT.EXECUTION_TIMESTAMP_DTTM IS 'Time that the execution result was created by the application';

COMMENT ON COLUMN RN_EXECUTION_RESULT.EXECUTION_RESULT_TYPE IS 'Type of payment associated with the execution result (TRANSFER, EXCHANGE, EXCHANGE_TRADE, RYPTO_TRANSFER)';

COMMENT ON COLUMN RN_EXECUTION_RESULT.EXECUTION_RESULT_ID IS 'Unique ID of the result';

COMMENT ON COLUMN RN_EXECUTION_RESULT.CREATED_DTTM IS 'Time that the result execution record was created';

COMMENT ON COLUMN RN_EXECUTION_RESULT.MODIFIED_DTTM IS 'Time that the result execution record was last modified';

CREATE INDEX IDX_EXEC_RESULT_PAYMENT ON RN_EXECUTION_RESULT(PAYMENT_ID);

-- Changeset db/paymentorchestrationservice/changelogs/base/changelog-execution-results.xml::oracle_sequence::payment_orchestration
-- Changeset db/paymentorchestrationservice/changelogs/base/quote-service-base-changelog.xml::create initial tables::bsundaravaradan
CREATE TABLE QUOTE (ID BIGSERIAL NOT NULL, QUOTE_ID UUID NOT NULL, RETURNS_PAYMENT_WITH_ID UUID, QUOTE_COLLECTION_ID UUID, ORIGINAL_PAYMENT_ID UUID, TYPE SMALLINT NOT NULL, EXPIRATION TIMESTAMP WITHOUT TIME ZONE NOT NULL, SENDING_ADDRESS VARCHAR(255) NOT NULL, RECEIVING_ADDRESS VARCHAR(255) NOT NULL, CURRENCY CHAR(3) NOT NULL, CURRENCY_CODE_FILTER CHAR(3), OUTBOUND_TRANSFER_FLAG BOOLEAN DEFAULT FALSE NOT NULL, AMOUNT numeric(28, 9) NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, SERVICE_TYPE VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT QUOTE_PKEY PRIMARY KEY (ID), UNIQUE (QUOTE_ID));

COMMENT ON TABLE QUOTE IS 'Quote records';

COMMENT ON COLUMN QUOTE.ID IS 'Database primary key';

COMMENT ON COLUMN QUOTE.QUOTE_ID IS 'Unique Quote ID';

COMMENT ON COLUMN QUOTE.RETURNS_PAYMENT_WITH_ID IS 'ID of the REGULAR payment that this quote (as part of the RETURN payment) is attempting to return';

COMMENT ON COLUMN QUOTE.QUOTE_COLLECTION_ID IS 'ID representing the collection of quotes in which this quote is grouped';

COMMENT ON COLUMN QUOTE.TYPE IS 'Denotes the type of Quote';

COMMENT ON COLUMN QUOTE.EXPIRATION IS 'Timestamp representing the quote expiry';

COMMENT ON COLUMN QUOTE.SENDING_ADDRESS IS 'RippleNet address of payment sender';

COMMENT ON COLUMN QUOTE.RECEIVING_ADDRESS IS 'RippleNet address of payment receiver';

COMMENT ON COLUMN QUOTE.CURRENCY IS 'Currency specified in the quote request';

COMMENT ON COLUMN QUOTE.CURRENCY_CODE_FILTER IS 'Currency code to filter out quote paths';

COMMENT ON COLUMN QUOTE.CREATED_AT IS 'Time that the quote object was created by the application';

COMMENT ON COLUMN QUOTE.CREATED_DTTM IS 'Time that the quote expiry record was created';

COMMENT ON COLUMN QUOTE.MODIFIED_DTTM IS 'Time that the quote expiry was last modified';

COMMENT ON COLUMN QUOTE.VERSION IS 'Internal value used by the database to update the quote record';

CREATE TABLE QUOTE_HOP (ID BIGSERIAL NOT NULL, QUOTE_HOP_ID UUID NOT NULL, SENDING_ADDRESS VARCHAR(255) NOT NULL, RECEIVING_ADDRESS VARCHAR(255) NOT NULL, SENDING_CURRENCY CHAR(3) NOT NULL, RECEIVING_CURRENCY CHAR(3) NOT NULL, SENDER_AMOUNT numeric(28, 9) NOT NULL, RECEIVER_AMOUNT numeric(28, 9) NOT NULL, SENDING_FEE numeric(28, 9) NOT NULL, RECEIVING_FEE numeric(28, 9) NOT NULL, FX_RATE numeric(28, 9) NOT NULL, BASE_CURRENCY CHAR(3), COUNTER_CURRENCY CHAR(3), RATE_TYPE VARCHAR(255), HOP_ORDER SMALLINT NOT NULL, QUOTE_ID UUID NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT QUOTE_HOP_PKEY PRIMARY KEY (ID), CONSTRAINT FK_QUOTE FOREIGN KEY (QUOTE_ID) REFERENCES QUOTE(QUOTE_ID), UNIQUE (QUOTE_HOP_ID));

COMMENT ON TABLE QUOTE_HOP IS 'Quote hop records';

COMMENT ON COLUMN QUOTE_HOP.ID IS 'Database primary key';

COMMENT ON COLUMN QUOTE_HOP.QUOTE_HOP_ID IS 'Universally Unique ID representing each quote hop publicly across RippleNet';

COMMENT ON COLUMN QUOTE_HOP.SENDING_ADDRESS IS 'RippleNet address of sender';

COMMENT ON COLUMN QUOTE_HOP.RECEIVING_ADDRESS IS 'RippleNet address of receiver';

COMMENT ON COLUMN QUOTE_HOP.SENDING_CURRENCY IS 'Currency of sender';

COMMENT ON COLUMN QUOTE_HOP.RECEIVING_CURRENCY IS 'Currency of receiver';

COMMENT ON COLUMN QUOTE_HOP.SENDER_AMOUNT IS 'Amount to send for this quote hop';

COMMENT ON COLUMN QUOTE_HOP.RECEIVER_AMOUNT IS 'Amount to be received for this quote hop';

COMMENT ON COLUMN QUOTE_HOP.SENDING_FEE IS 'Fee to be applied to sending amount';

COMMENT ON COLUMN QUOTE_HOP.RECEIVING_FEE IS 'Fee to be applied to the receiving amount';

COMMENT ON COLUMN QUOTE_HOP.FX_RATE IS 'Rate to be applied to this quote hop';

COMMENT ON COLUMN QUOTE_HOP.BASE_CURRENCY IS 'Base currency for this quote hop';

COMMENT ON COLUMN QUOTE_HOP.COUNTER_CURRENCY IS 'Counter currency for this quote hop';

COMMENT ON COLUMN QUOTE_HOP.RATE_TYPE IS 'Rate type for this quote hop';

COMMENT ON COLUMN QUOTE_HOP.HOP_ORDER IS 'Order of the hop in this quote';

COMMENT ON COLUMN QUOTE_HOP.QUOTE_ID IS 'Universally Unique ID representing the quote to which this quote hop belongs';

COMMENT ON COLUMN QUOTE_HOP.CREATED_DTTM IS 'Time that the quote hop record was created';

COMMENT ON COLUMN QUOTE_HOP.MODIFIED_DTTM IS 'Time that the quote hop record was last modified';

CREATE UNIQUE INDEX IDX_QUOTE_ID_HOP_ORDER ON QUOTE_HOP(QUOTE_ID, HOP_ORDER);

-- Changeset db/paymentorchestrationservice/changelogs/base/quote-service-base-changelog.xml::oracle_sequence::quotes
-- Changeset db/paymentorchestrationservice/changelogs/base/quote-service-base-changelog.xml::path-persistance::jjanardhanan
CREATE TABLE MESSAGE_PATH (ID BIGSERIAL NOT NULL, MESSAGE_KEY UUID NOT NULL, FORWARD_PATH BYTEA, BACKWARD_PATH BYTEA, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT MESSAGE_PATH_PKEY PRIMARY KEY (ID));

COMMENT ON COLUMN MESSAGE_PATH.CREATED_DTTM IS 'Time that the message path record was created';

COMMENT ON COLUMN MESSAGE_PATH.MODIFIED_DTTM IS 'Time that the message path record was last modified';

CREATE INDEX IDX_MESSAGE_PATH_MSGKEY ON MESSAGE_PATH(MESSAGE_KEY);

-- Changeset db/paymentorchestrationservice/changelogs/base/quote-service-base-changelog.xml::message-path-seq::jjanardhanan
-- Changeset db/paymentorchestrationservice/changelogs/base/quote-service-base-changelog.xml::XRAP-575-add-payment-method-to-quote::imalygin
ALTER TABLE QUOTE ADD PAYMENT_METHOD VARCHAR(32) DEFAULT 'false';

-- Changeset db/paymentorchestrationservice/changelogs/4.0.1/changelog.xml::drop tables::niranjan
DROP TABLE PAYMENT_EXPIRY CASCADE;

-- Changeset db/paymentorchestrationservice/changelogs/4.0.1/quote-service-4.0.1-changelog.xml::create tables for 4.0.1 release::niranjan
CREATE TABLE QUOTE_EXPIRY (ID BIGSERIAL NOT NULL, QUOTE_TTL_MS BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT QUOTE_EXPIRY_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE QUOTE_EXPIRY IS 'Quote expiry setting';

COMMENT ON COLUMN QUOTE_EXPIRY.ID IS 'Database primary key';

COMMENT ON COLUMN QUOTE_EXPIRY.QUOTE_TTL_MS IS 'Quote expiry in milliseconds';

COMMENT ON COLUMN QUOTE_EXPIRY.CREATED_DTTM IS 'Time that the quote expiry record was created';

COMMENT ON COLUMN QUOTE_EXPIRY.MODIFIED_DTTM IS 'Time that the quote expiry record was last modified';

-- Changeset db/paymentorchestrationservice/changelogs/4.0.1/quote-service-4.0.1-changelog.xml::change datetime to timestamp::bsundaravaradan
ALTER TABLE QUOTE ALTER COLUMN CREATED_AT TYPE TIMESTAMP WITHOUT TIME ZONE USING (CREATED_AT::TIMESTAMP WITHOUT TIME ZONE);

ALTER TABLE QUOTE ALTER COLUMN EXPIRATION TYPE TIMESTAMP WITHOUT TIME ZONE USING (EXPIRATION::TIMESTAMP WITHOUT TIME ZONE);

ALTER TABLE QUOTE ALTER COLUMN CREATED_DTTM TYPE TIMESTAMP WITHOUT TIME ZONE USING (CREATED_DTTM::TIMESTAMP WITHOUT TIME ZONE);

ALTER TABLE QUOTE ALTER COLUMN MODIFIED_DTTM TYPE TIMESTAMP WITHOUT TIME ZONE USING (MODIFIED_DTTM::TIMESTAMP WITHOUT TIME ZONE);

ALTER TABLE QUOTE_HOP ALTER COLUMN CREATED_DTTM TYPE TIMESTAMP WITHOUT TIME ZONE USING (CREATED_DTTM::TIMESTAMP WITHOUT TIME ZONE);

ALTER TABLE QUOTE_HOP ALTER COLUMN MODIFIED_DTTM TYPE TIMESTAMP WITHOUT TIME ZONE USING (MODIFIED_DTTM::TIMESTAMP WITHOUT TIME ZONE);

-- Changeset db/paymentorchestrationservice/changelogs/4.0.1/quote-service-4.0.1-changelog.xml::oracle_sequence_quote_expiry::niranjan
-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/changelog.xml::change column precision::bsundaravaradan
ALTER TABLE RN_EXECUTION_RESULT ALTER COLUMN SENDER_AMOUNT TYPE numeric(28, 9) USING (SENDER_AMOUNT::numeric(28, 9));

ALTER TABLE RN_EXECUTION_RESULT ALTER COLUMN RECEIVER_AMOUNT TYPE numeric(28, 9) USING (RECEIVER_AMOUNT::numeric(28, 9));

ALTER TABLE RN_EXECUTION_RESULT ALTER COLUMN SENDING_FEE TYPE numeric(28, 9) USING (SENDING_FEE::numeric(28, 9));

ALTER TABLE RN_EXECUTION_RESULT ALTER COLUMN RECEIVING_FEE TYPE numeric(28, 9) USING (RECEIVING_FEE::numeric(28, 9));

ALTER TABLE RN_EXECUTION_RESULT ALTER COLUMN FX_RATE TYPE numeric(28, 10) USING (FX_RATE::numeric(28, 10));

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/changelog.xml::request-for-payment::lreyes
CREATE TABLE REQUEST_FOR_PAYMENT (ID BIGSERIAL NOT NULL, REQUEST_FOR_PAYMENT_ID UUID NOT NULL, END_TO_END_ID VARCHAR(255), CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, REQUEST_FOR_PAYMENT_STATE SMALLINT NOT NULL, SENDER_ADDRESS VARCHAR(255) NOT NULL, RECEIVER_ADDRESS VARCHAR(255) NOT NULL, AMOUNT numeric(28, 9) NOT NULL, CURRENCY CHAR(3) NOT NULL, QUOTE_TYPE SMALLINT NOT NULL, PAYMENT_ID UUID, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT REQUEST_FOR_PAYMENT_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE REQUEST_FOR_PAYMENT IS 'Request for payment records';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.ID IS 'Database primary key';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.REQUEST_FOR_PAYMENT_ID IS 'Universally Unique ID representing the request for payment publicly across RippleNet';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.END_TO_END_ID IS 'ID set by the request for payment sender and persisted on all xCurrent instances that participate in the payment chain';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.CREATED_AT IS 'Time that the request for payment object was created by the application of the request for payment sender';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.REQUEST_FOR_PAYMENT_STATE IS 'State of the request for payment in the payment chain (REQUESTED, ACCEPTED, FAILED)';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.SENDER_ADDRESS IS 'RippleNet Address of the request for payment sender (the eventual payment beneficiary)';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.RECEIVER_ADDRESS IS 'RippleNet Address of the request for payment receiver (the payment originator)';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.AMOUNT IS 'Payment amount that is being requested';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.CURRENCY IS 'Currency of the requested payment amount';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.QUOTE_TYPE IS 'Quote type of the request for payment (SENDER_AMOUNT, RECEIVER_AMOUNT, SENDER_INSTITUTION_AMOUNT, RECEIVER_INSTITUTION_AMOUNT)';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.PAYMENT_ID IS 'Universally Unique ID representing the payment that fulfills the request for payment';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.CREATED_DTTM IS 'Time that the request for payment record was created';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.MODIFIED_DTTM IS 'Time that the request for payment record was last modified';

COMMENT ON COLUMN REQUEST_FOR_PAYMENT.VERSION IS 'Internal value used by the database to update the request for payment record';

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/changelog.xml::request_for_payment_user_info::lreyes
CREATE TABLE RFP_USER_INFO_ENTRY (ID BIGSERIAL NOT NULL, REQUEST_FOR_PAYMENT_ID UUID NOT NULL, STATE VARCHAR(255) NOT NULL, NODE_ADDRESS VARCHAR(255) NOT NULL, JSON OID NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT RFP_USER_INFO_ENTRY_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE RFP_USER_INFO_ENTRY IS 'User info entry associated with a request';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.ID IS 'Database primary key';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.REQUEST_FOR_PAYMENT_ID IS 'Universally Unique ID representing the request for payment publicly across RippleNet';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.STATE IS 'State of the request for payment at which the user info was added (REQUESTED, ACCEPTED, FAILED)';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.NODE_ADDRESS IS 'RippleNet Address of the xCurrent node that added the user info';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.JSON IS 'Content of the user info list';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.CREATED_AT IS 'Time that the request for payment user info list was created by the application of the request for payment sender';

COMMENT ON COLUMN RFP_USER_INFO_ENTRY.CREATED_DTTM IS 'Time that the request for payment user info record was last modified';

CREATE INDEX IDX_RFP_USER_INFO ON RFP_USER_INFO_ENTRY(REQUEST_FOR_PAYMENT_ID);

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/changelog.xml::add_background_job_status_column::bsundaravaradan
ALTER TABLE PAYMENT ADD BACKGROUND_JOB_STATUS SMALLINT DEFAULT 0 NOT NULL;

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/changelog.xml::Add indexes::bsundaravaradan
CREATE INDEX IDX_PYMT_QUOTE_ID ON PAYMENT(QUOTE_ID);

CREATE INDEX IDX_QTE_QTC_ID ON QUOTE(QUOTE_COLLECTION_ID);

CREATE INDEX IDX_PYMTLB_ACTIVE_PAYMENT_ID ON PAYMENT_LABEL(PAYMENT_ID, ACTIVE);

CREATE INDEX IDX_PYMTLB_ACTIVE_LABEL_ID ON PAYMENT_LABEL(LABEL, ACTIVE);

CREATE INDEX IDX_RNI_PAYMENT_ID ON RIPPLE_NET_INFO_ENTRY(PAYMENT_ID);

CREATE INDEX IDX_USRI_ENTITY_TYPE_ID ON USER_INFO_ENTRY(ENTITY_TYPE_ID);

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/quote-service-4.0.2-changelog.xml::create tables for 4.0.2 release::imalygin
CREATE TABLE QUOTE_ERROR (ID BIGSERIAL NOT NULL, QUOTE_COLLECTION_ID UUID, FAILED_PATHS BYTEA, ERROR_ORIGIN VARCHAR(255), ERROR_MESSAGE VARCHAR(1024), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT QUOTE_ERROR_PKEY PRIMARY KEY (ID));

-- Changeset db/paymentorchestrationservice/changelogs/4.1.0/quote-service-4.0.2-changelog.xml::oracle_sequence_quote_error::imalygin
-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add PROPAGATION_FLAG column to USER_INFO_ENTRY::imalygin
ALTER TABLE USER_INFO_ENTRY ADD PROPAGATION_FLAG BOOLEAN DEFAULT FALSE NOT NULL;

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add USER_INFO_ID column to USER_INFO_ENTRY::imalygin
ALTER TABLE USER_INFO_ENTRY ADD USER_INFO_ID VARCHAR(36);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Populate user_info_id column::imalygin
UPDATE USER_INFO_ENTRY SET USER_INFO_ID = md5(random()::text || clock_timestamp()::text)::uuid;

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Update USER_INFO_ID to non-nullable::imalygin
ALTER TABLE USER_INFO_ENTRY ALTER COLUMN  USER_INFO_ID SET NOT NULL;

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add unique index for USER_INFO_ID to USER_INFO_ENTRY::imalygin
CREATE UNIQUE INDEX IDX_USER_INFO_ID ON USER_INFO_ENTRY(USER_INFO_ID);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add index for PAYMENT_ID and PROPAGATION_FLAG to USER_INFO_ENTRY::imalygin
CREATE INDEX IDX_PMNT_ID_PROP_FLG ON USER_INFO_ENTRY(ENTITY_TYPE_ID, PROPAGATION_FLAG);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add USER_INFO_COMPLETE_FLAG column to PAYMENT::imalygin
ALTER TABLE PAYMENT ADD USER_INFO_COMPLETE_FLAG BOOLEAN DEFAULT FALSE NOT NULL;

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add index for USER_INFO_COMPLETE_FLAG to PAYMENT::imalygin
CREATE INDEX IDX_USR_INF_CMPLT_FLG ON PAYMENT(USER_INFO_COMPLETE_FLAG);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add SUB_STATE column to USER_INFO_ENTRY::imalygin
ALTER TABLE USER_INFO_ENTRY ADD SUB_STATE VARCHAR(255);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add SENDING_HOST column::imalygin
ALTER TABLE QUOTE ADD SENDING_HOST VARCHAR(255);

-- Changeset db/paymentorchestrationservice/changelogs/4.2.0/changelog.xml::Add index for SENDING_HOST to QUOTE::imalygin
CREATE INDEX IDX_QUOTE_SND_HOST_QT_ID ON QUOTE(SENDING_HOST, QUOTE_ID);

-- Changeset db/paymentorchestrationservice/changelogs/4.3.0/changelog.xml::Add SENDING_FEE column to TRANSFER::ztotta
ALTER TABLE TRANSFER ADD SENDING_FEE numeric(28, 9);

COMMENT ON COLUMN TRANSFER.SENDING_FEE IS 'Sending fee applied to sender amount';

-- Changeset db/paymentorchestrationservice/changelogs/4.3.0/changelog.xml::Add QuoteElementType to QUOTE_HOP::bsundaravaradan
ALTER TABLE QUOTE_HOP ADD QUOTE_ELEMENT_TYPE VARCHAR(255);

COMMENT ON COLUMN QUOTE_HOP.QUOTE_ELEMENT_TYPE IS 'Type of quote element (EXCHANGE, TRANSFER, EXCHANGE_TRADE, CRYPTO_TRANSFER)';

-- Changeset db/paymentorchestrationservice/changelogs/4.3.0/changelog.xml::Add ExecutionResult fields::bsundaravaradan
ALTER TABLE RN_EXECUTION_RESULT ADD INTERMEDIARY_DELTA numeric(28, 9);

ALTER TABLE RN_EXECUTION_RESULT ADD INCENTIVE_TYPE VARCHAR(255);

COMMENT ON COLUMN RN_EXECUTION_RESULT.INTERMEDIARY_DELTA IS 'Amount of XRP representing the difference in FX rate between the moment of quoting and the moment of execution.';

COMMENT ON COLUMN RN_EXECUTION_RESULT.INCENTIVE_TYPE IS 'Configuration of the incentive pool on the xRapid side (FIRM, FX)';

-- Changeset db/paymentorchestrationservice/changelogs/4.3.0/changelog.xml::Add index IDX_PYMT_STATE_JOB_EXPR::lzhang
CREATE INDEX IDX_PYMT_STATE_JOB_EXPR ON PAYMENT(PAYMENT_STATE, BACKGROUND_JOB_STATUS, EXPIRES_AT);

-- Changeset db/paymentorchestrationservice/changelogs/4.4.0/changelog.xml::Add separate account and ripplenet address fields::mdevidi
ALTER TABLE PAYMENT ADD SENDING_ACCOUNT VARCHAR(255);

ALTER TABLE PAYMENT ADD RECEIVING_ACCOUNT VARCHAR(255);

ALTER TABLE PAYMENT ADD SENDING_HOST VARCHAR(255);

ALTER TABLE PAYMENT ADD RECEIVING_HOST VARCHAR(255);

ALTER TABLE PAYMENT ADD SENDING_CURRENCY CHAR(3);

ALTER TABLE PAYMENT ADD SENDING_AMOUNT numeric(28, 9);

ALTER TABLE PAYMENT ADD RECEIVING_CURRENCY CHAR(3);

ALTER TABLE PAYMENT ADD RECEIVING_AMOUNT numeric(28, 9);

ALTER TABLE PAYMENT ADD EXECUTED_DTTM TIMESTAMP WITHOUT TIME ZONE;

COMMENT ON COLUMN PAYMENT.SENDING_ACCOUNT IS 'Payment sender account';

COMMENT ON COLUMN PAYMENT.RECEIVING_ACCOUNT IS 'Payment receiver account';

COMMENT ON COLUMN PAYMENT.SENDING_HOST IS 'Payment sender host';

COMMENT ON COLUMN PAYMENT.RECEIVING_HOST IS 'Payment receiver host';

COMMENT ON COLUMN PAYMENT.SENDING_CURRENCY IS 'Sending currency of the payment';

COMMENT ON COLUMN PAYMENT.SENDING_AMOUNT IS 'Sending amount of the payment';

COMMENT ON COLUMN PAYMENT.RECEIVING_CURRENCY IS 'Receiving currency of the payment';

COMMENT ON COLUMN PAYMENT.RECEIVING_AMOUNT IS 'Receiving amount of the payment';

COMMENT ON COLUMN PAYMENT.EXECUTED_DTTM IS 'Receiving amount of the payment';

-- Changeset db/paymentorchestrationservice/changelogs/4.4.0/changelog.xml::Change UserInfoEntryID to UUID from varchar::lzhang
CREATE TABLE RIPPLENET_MIGRATION (ID BIGINT, USER_INFO_ID VARCHAR(36));

insert into RIPPLENET_MIGRATION (ID, USER_INFO_ID) select ID, USER_INFO_ID from USER_INFO_ENTRY;

CREATE UNIQUE INDEX IDX_RIPPLENET_MIGRATION ON RIPPLENET_MIGRATION(ID, USER_INFO_ID);

ALTER TABLE USER_INFO_ENTRY ALTER COLUMN  USER_INFO_ID DROP NOT NULL;

UPDATE USER_INFO_ENTRY SET USER_INFO_ID = NULL;

ALTER TABLE USER_INFO_ENTRY ALTER COLUMN USER_INFO_ID TYPE UUID USING (USER_INFO_ID::UUID);

update USER_INFO_ENTRY set USER_INFO_ID = uuid(RIPPLENET_MIGRATION.USER_INFO_ID) from RIPPLENET_MIGRATION where USER_INFO_ENTRY.ID = RIPPLENET_MIGRATION.ID;

ALTER TABLE USER_INFO_ENTRY ALTER COLUMN  USER_INFO_ID SET NOT NULL;

DROP TABLE RIPPLENET_MIGRATION;

-- Changeset db/paymentorchestrationservice/changelogs/4.4.0/changelog.xml::RNFS-3026_payment_data_migration::lzhang
update payment set SENDING_ACCOUNT=qt.sa, SENDING_HOST=qt.sh, RECEIVING_ACCOUNT=qt.ra, RECEIVING_HOST=qt.rh
            from (select q.quote_id,
            substring(q.SENDING_ADDRESS, 1, position('@' in q.SENDING_ADDRESS)-1) as sa,
            substring(q.SENDING_ADDRESS, position('@' in q.SENDING_ADDRESS)+1) as sh,
            substring(q.RECEIVING_ADDRESS, 1, position('@' in q.RECEIVING_ADDRESS)-1) as ra,
            substring(q.RECEIVING_ADDRESS, position('@' in q.RECEIVING_ADDRESS)+1) as rh
            from quote as q
            ) qt
            where payment.quote_id = qt.quote_id;

update payment set SENDING_CURRENCY=qh.c, SENDING_AMOUNT=qh.a
            from (
            select q.quote_id, q.sending_currency as c, q.sender_amount as a
            from quote_hop q
            where q.id in (select min(id) from quote_hop group by quote_id)
            ) qh
            where payment.quote_id = qh.quote_id;

update payment set RECEIVING_CURRENCY=qh.c, RECEIVING_AMOUNT=qh.a
            from (
            select q.quote_id, q.receiving_currency as c, q.receiver_amount as a
            from quote_hop q
            where q.id in (select max(id) from quote_hop group by quote_id)
            ) qh
            where payment.quote_id = qh.quote_id;

update payment set executed_dttm = er.ts
            from (
            select r.payment_id, r.execution_timestamp_dttm as ts
            from rn_execution_result r
            where r.id in (select max(id) from rn_execution_result group by payment_id)
            ) er
            where payment.payment_id = er.payment_id;

-- Changeset db/paymentorchestrationservice/changelogs/4.4.0/changelog.xml::Adding not null constraint to PaymentDetailEntity fields::mdevidi
ALTER TABLE PAYMENT ALTER COLUMN  SENDING_HOST SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  RECEIVING_HOST SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  SENDING_CURRENCY SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  RECEIVING_CURRENCY SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  SENDING_AMOUNT SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  RECEIVING_AMOUNT SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  SENDING_ACCOUNT SET NOT NULL;

ALTER TABLE PAYMENT ALTER COLUMN  RECEIVING_ACCOUNT SET NOT NULL;

-- Changeset db/paymentorchestrationservice/changelogs/4.4.0/changelog.xml::Add indices IDX_PYMT_SENDING_HOST, IDX_PYMT_SENDING_HOST::mdevidi
CREATE INDEX IDX_PYMT_SENDING_HOST ON PAYMENT(SENDING_HOST);

CREATE INDEX IDX_PYMT_RECEIVING_HOST ON PAYMENT(RECEIVING_HOST);

CREATE INDEX IDX_PYMT_SENDING_ACCOUNT ON PAYMENT(SENDING_ACCOUNT);

CREATE INDEX IDX_PYMT_RECEIVING_ACCOUNT ON PAYMENT(RECEIVING_ACCOUNT);

CREATE INDEX IDX_PYMT_SENDING_CURRENCY ON PAYMENT(SENDING_CURRENCY);

CREATE INDEX IDX_PYMT_RECEIVING_CURRENCY ON PAYMENT(RECEIVING_CURRENCY);

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/peerservice/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/peerservice/changelogs/base/changelog.xml::create initial tables::Service Archetype
CREATE TABLE RIPPLE_NET_NODE (ID UUID NOT NULL, ADDRESS VARCHAR(255) NOT NULL, DESCRIPTION VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT RIPPLE_NET_NODE_PKEY PRIMARY KEY (ID), UNIQUE (ADDRESS));

COMMENT ON TABLE RIPPLE_NET_NODE IS 'Stores information about a RippleNet node such as xCurrent or xRRN';

COMMENT ON COLUMN RIPPLE_NET_NODE.ID IS 'Database primary key';

COMMENT ON COLUMN RIPPLE_NET_NODE.ADDRESS IS 'Unique address of a node on the RippleNet network represented as account@host or host only';

COMMENT ON COLUMN RIPPLE_NET_NODE.DESCRIPTION IS 'Description of this RippleNet node';

COMMENT ON COLUMN RIPPLE_NET_NODE.CREATED_DTTM IS 'Time that the ripple_net_node record was created';

COMMENT ON COLUMN RIPPLE_NET_NODE.MODIFIED_DTTM IS 'Time that the ripple_net_node record was last modified';

COMMENT ON COLUMN RIPPLE_NET_NODE.VERSION IS 'Internal value used by the database to update the ripple_net_node record';

CREATE TABLE PEER (ID UUID NOT NULL, NODE_ID UUID NOT NULL, ADDRESS VARCHAR(255) NOT NULL, ENDPOINT VARCHAR(255) NOT NULL, DESCRIPTION VARCHAR(255) NOT NULL, ACTIVE BOOLEAN NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT PEER_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE PEER IS 'Stores information about RippleNet nodes with which this node is connected';

COMMENT ON COLUMN PEER.ID IS 'Database primary key';

COMMENT ON COLUMN PEER.NODE_ID IS 'UUID representing a peer node publicly across RippleNet';

COMMENT ON COLUMN PEER.ADDRESS IS 'Unique address of a peer node on the RippleNet network represented as account@host or host only';

COMMENT ON COLUMN PEER.ENDPOINT IS 'HTTP URL of a peer node';

COMMENT ON COLUMN PEER.DESCRIPTION IS 'Description of a RippleNet peer node';

COMMENT ON COLUMN PEER.ACTIVE IS 'True/False flag that indicates if the peer has an active connection';

COMMENT ON COLUMN PEER.CREATED_DTTM IS 'Time that the peer record was created';

COMMENT ON COLUMN PEER.MODIFIED_DTTM IS 'Time that the peer record was last modified';

COMMENT ON COLUMN PEER.VERSION IS 'Internal value used by the database to update the peer record';

CREATE TABLE LIQUIDITY_RELATIONSHIP (ID UUID NOT NULL, PEER_ID UUID NOT NULL, ACCOUNT VARCHAR(255) NOT NULL, CURRENCY VARCHAR(5) NOT NULL, TYPE VARCHAR(25) NOT NULL, STATUS VARCHAR(25) NOT NULL, POLICY VARCHAR(25) NOT NULL, DESCRIPTION VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT LIQUIDITY_RELATIONSHIP_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE LIQUIDITY_RELATIONSHIP IS 'Stores information about liquidity relationships, which are links (both technical and financial) between two accounts on two different ledgers';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.ID IS 'Database primary key';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.PEER_ID IS 'UUID representing the peer node in this liquidity relationship';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.ACCOUNT IS 'The liquidity relationship account name';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.CURRENCY IS 'The liquidity relationship currency';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.TYPE IS 'The liquidity relationship type (NOSTRO, VOSTRO, CRYPTO)';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.STATUS IS 'The liquidity relationship status (PENDING, ENABLED, DISABLED)';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.POLICY IS 'The liquidity relationship policy (NONE, SINGLE, MULTIPLE)';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.DESCRIPTION IS 'Description of this liquidity relationship';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.CREATED_DTTM IS 'Time that the liquidity_relationship record was created';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.MODIFIED_DTTM IS 'Time that the liquidity_relationship record was last modified';

COMMENT ON COLUMN LIQUIDITY_RELATIONSHIP.VERSION IS 'Internal value used by the database to update the liquidity_relationship record';

CREATE TABLE ROUTE_PATTERN (ID UUID NOT NULL, PEER_ID UUID NOT NULL, PATTERN VARCHAR(255) NOT NULL, PATTERN_TYPE VARCHAR(255) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT ROUTE_PATTERN_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE ROUTE_PATTERN IS 'Stores the pattern of a RippleNet address (between a node and its peer)';

COMMENT ON COLUMN ROUTE_PATTERN.ID IS 'Database primary key';

COMMENT ON COLUMN ROUTE_PATTERN.PEER_ID IS 'UUID representing the peer node in this route pattern';

COMMENT ON COLUMN ROUTE_PATTERN.PATTERN IS 'Actual RippleNet address pattern, e.g., rn.*';

COMMENT ON COLUMN ROUTE_PATTERN.PATTERN_TYPE IS 'Type of pattern (REGEX, PREFIX)';

COMMENT ON COLUMN ROUTE_PATTERN.CREATED_DTTM IS 'Time that the route_pattern record was created';

COMMENT ON COLUMN ROUTE_PATTERN.MODIFIED_DTTM IS 'Time that the route_pattern record was last modified';

COMMENT ON COLUMN ROUTE_PATTERN.VERSION IS 'Internal value used by the database to update the route_pattern record';

ALTER TABLE PEER ADD CONSTRAINT FK_PEER_NODE_ID FOREIGN KEY (NODE_ID) REFERENCES RIPPLE_NET_NODE (ID) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE ROUTE_PATTERN ADD CONSTRAINT FK_PEER_ROUTE_PATTERN_ID FOREIGN KEY (PEER_ID) REFERENCES PEER (ID) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE LIQUIDITY_RELATIONSHIP ADD CONSTRAINT FK_PEER_LIQUIDITY_ID FOREIGN KEY (PEER_ID) REFERENCES PEER (ID) ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE PEER ADD CONSTRAINT IDX_NODE_ID_ADDRESS UNIQUE (NODE_ID, ADDRESS);

ALTER TABLE LIQUIDITY_RELATIONSHIP ADD CONSTRAINT IDX_PEER_ID_ACCOUNT UNIQUE (PEER_ID, ACCOUNT);

ALTER TABLE ROUTE_PATTERN ADD CONSTRAINT IDX_PEER_ID_PATTERN UNIQUE (PEER_ID, PATTERN);

-- Changeset db/peerservice/changelogs/base/changelog.xml::RNXC-2094::jjanardhanan
ALTER TABLE PEER ADD MESSAGE_ENCRYPTION_ENABLED BOOLEAN DEFAULT FALSE NOT NULL;

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/ripplenetpublickeyservice/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/ripplenetpublickeyservice/changelogs/base/changelog.xml::create initial tables::Service Archetype
CREATE TABLE PUBLIC_KEY_TYPE (PUBLIC_KEY_TYPE_ID BIGSERIAL NOT NULL, PUBLIC_KEY_ORDINAL INTEGER NOT NULL, PUBLIC_KEY_TYPE_NAME VARCHAR(100) NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, CONSTRAINT PUBLIC_KEY_TYPE_PKEY PRIMARY KEY (PUBLIC_KEY_TYPE_ID), UNIQUE (PUBLIC_KEY_TYPE_NAME), UNIQUE (PUBLIC_KEY_ORDINAL));

COMMENT ON COLUMN PUBLIC_KEY_TYPE.PUBLIC_KEY_TYPE_ID IS 'Database primary key';

COMMENT ON COLUMN PUBLIC_KEY_TYPE.PUBLIC_KEY_ORDINAL IS 'Ordered integer value that corresponds to the public key type';

COMMENT ON COLUMN PUBLIC_KEY_TYPE.PUBLIC_KEY_TYPE_NAME IS 'Name of the public key type';

COMMENT ON COLUMN PUBLIC_KEY_TYPE.CREATED_DTTM IS 'Time that the public key type record was created';

COMMENT ON COLUMN PUBLIC_KEY_TYPE.MODIFIED_DTTM IS 'Time that the public key type record was last modified';

CREATE TABLE RIPPLENET_ADDRESS_RECORD (ADDRESS_ID BIGSERIAL NOT NULL, RIPPLENET_ADDRESS VARCHAR(4000) NOT NULL, IS_DISABLED BOOLEAN DEFAULT FALSE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT RIPPLENET_ADDRESS_RECORD_PKEY PRIMARY KEY (ADDRESS_ID), UNIQUE (RIPPLENET_ADDRESS));

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.ADDRESS_ID IS 'Database primary key';

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.RIPPLENET_ADDRESS IS 'The Ripplenet address for this record';

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.IS_DISABLED IS 'Active/non-active status of the Ripplenet address';

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.CREATED_DTTM IS 'Time that the ripplenet address record was created';

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.MODIFIED_DTTM IS 'Time that the ripplenet address record was last modified';

COMMENT ON COLUMN RIPPLENET_ADDRESS_RECORD.VERSION IS 'Internal value used by the database to update the record';

CREATE TABLE RIPPLENET_PUBLIC_KEY_RECORD (PUBLIC_KEY_ID BIGSERIAL NOT NULL, RIPPLENET_ADDRESS_ID BIGINT NOT NULL, PUBLIC_KEY BYTEA NOT NULL, KEY_TYPE INTEGER NOT NULL, KEY_VERSION INTEGER NOT NULL, EXPIRY_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, IS_DISABLED BOOLEAN DEFAULT FALSE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT RIPPLENET_PUBLIC_KEY_RECORD_PKEY PRIMARY KEY (PUBLIC_KEY_ID), CONSTRAINT FK_RIPPLENET_ADDRESS FOREIGN KEY (RIPPLENET_ADDRESS_ID) REFERENCES RIPPLENET_ADDRESS_RECORD(ADDRESS_ID), CONSTRAINT FK_KEY_TYPE_NAME FOREIGN KEY (KEY_TYPE) REFERENCES PUBLIC_KEY_TYPE(PUBLIC_KEY_ORDINAL));

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.PUBLIC_KEY_ID IS 'Database primary key';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.RIPPLENET_ADDRESS_ID IS 'ID of the Ripplenet address used by this public key';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.PUBLIC_KEY IS 'Binary representation of the public key data';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.KEY_TYPE IS 'Type of the public key (ED_25519, RSA)';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.KEY_VERSION IS 'Version of the public key';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.EXPIRY_DTTM IS 'Expiration date of the public key';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.IS_DISABLED IS 'Active/non-active status of the public key';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.CREATED_DTTM IS 'Time that the ripplenet public key record record was created';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.MODIFIED_DTTM IS 'Time that the record was ripplenet public key record last modified';

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.VERSION IS 'Internal value used by the database to update the record';

CREATE INDEX FK_ADDRESS_ID ON RIPPLENET_PUBLIC_KEY_RECORD(RIPPLENET_ADDRESS_ID);

ALTER TABLE RIPPLENET_PUBLIC_KEY_RECORD ADD UNIQUE (RIPPLENET_ADDRESS_ID, KEY_TYPE, KEY_VERSION);

CREATE INDEX PUBLIC_KEY_EXPIRY_DTTM_IDX ON RIPPLENET_PUBLIC_KEY_RECORD(EXPIRY_DTTM);

-- Changeset db/ripplenetpublickeyservice/changelogs/base/changelog.xml::oracle_sequence::quotes
-- Changeset db/ripplenetpublickeyservice/changelogs/base/changelog.xml::populate key type lookup table::mphinney
-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO PUBLIC_KEY_TYPE (PUBLIC_KEY_TYPE_ID, PUBLIC_KEY_ORDINAL, PUBLIC_KEY_TYPE_NAME) VALUES ('1', '0', 'ED25519');

-- Changeset db/ripplenetpublickeyservice/changelogs/base/changelog.xml::add RSA Key Type::jjanardhanan
INSERT INTO PUBLIC_KEY_TYPE (PUBLIC_KEY_TYPE_ID, PUBLIC_KEY_ORDINAL, PUBLIC_KEY_TYPE_NAME, CREATED_DTTM, MODIFIED_DTTM) VALUES (2, 1, 'RSA', NOW(), NOW());

-- Changeset db/ripplenetpublickeyservice/changelogs/4.1.0/changelog.xml::Add indexes::bsundaravaradan
CREATE INDEX IDX_RPKR_RNADDR_EXPIRY ON RIPPLENET_PUBLIC_KEY_RECORD(RIPPLENET_ADDRESS_ID, IS_DISABLED, EXPIRY_DTTM);

-- Changeset db/ripplenetpublickeyservice/changelogs/4.1.0/changelog.xml::add column KEY_INTENT to RIPPLENET_PUBLIC_KEY_RECORD::nbondugula
ALTER TABLE RIPPLENET_PUBLIC_KEY_RECORD ADD KEY_INTENT INTEGER DEFAULT 0;

COMMENT ON COLUMN RIPPLENET_PUBLIC_KEY_RECORD.KEY_INTENT IS 'Public key usage (SIGNING_PUBLIC_KEY, MESSAGE_ENCRYPTION_KEY)';

-- Changeset db/ripplenetpublickeyservice/changelogs/4.1.0/changelog.xml::drop index::nbondugula
DROP INDEX IDX_RPKR_RNADDR_EXPIRY;

-- Changeset db/ripplenetpublickeyservice/changelogs/4.1.0/changelog.xml::Add indexes::nbondugula
CREATE INDEX IDX_RPKR_RNADDR_EXPIRY_INTENT ON RIPPLENET_PUBLIC_KEY_RECORD(RIPPLENET_ADDRESS_ID, IS_DISABLED, EXPIRY_DTTM, KEY_INTENT);

-- Changeset db/ripplenetpublickeyservice/changelogs/4.1.0/changelog.xml::Temporarily drop RIPPLENET_ADDRESS constraint::cdmcnamara
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/validator/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/validator/changelogs/base/changelog.xml::create transactions table::dfuelling
CREATE TABLE crypto_transaction (id BIGSERIAL NOT NULL, crypto_tx_id VARCHAR(255) NOT NULL, state_hint INTEGER NOT NULL, execution_condition BYTEA, cancellation_condition BYTEA, attested_execute_condition BYTEA NOT NULL, attested_cancel_condition BYTEA, attested_expire_condition BYTEA, published_fulfillment BYTEA, attestation_fulfillment BYTEA, finalized_dttm_hint TIMESTAMP WITHOUT TIME ZONE, expires_dttm TIMESTAMP WITHOUT TIME ZONE NOT NULL, created_dttm TIMESTAMP WITHOUT TIME ZONE NOT NULL, modified_dttm TIMESTAMP WITHOUT TIME ZONE NOT NULL, version SMALLINT NOT NULL, CONSTRAINT CRYPTO_TRANSACTION_PKEY PRIMARY KEY (id), UNIQUE (crypto_tx_id));

COMMENT ON TABLE crypto_transaction IS 'Stores crypto-transactions which represent a business transaction in some external system. Crypto-transactions begin in the PENDING state, and eventually transition to a finalized state (EXECUTED, CANCELLED, EXPIRED).';

COMMENT ON COLUMN crypto_transaction.id IS 'Unique and auto-incremental database primary key';

COMMENT ON COLUMN crypto_transaction.crypto_tx_id IS 'Unique crypto-transaction identifier';

COMMENT ON COLUMN crypto_transaction.state_hint IS 'Hint about the state of this transaction (for querying) which must come from inspecting the fulfillment, if present';

COMMENT ON COLUMN crypto_transaction.execution_condition IS 'An execution-condition for this crypto-transaction, stored in ASN.1 DER-encoded binary form';

COMMENT ON COLUMN crypto_transaction.cancellation_condition IS 'An optional cancellation condition for this crypto-transaction, stored in ASN.1 DER-encoded binary form';

COMMENT ON COLUMN crypto_transaction.attested_execute_condition IS 'A threshold condition that, when fulfilled, allows a client to determine, in a cryptographically provable manner, if this crypto-transaction has been EXECUTED';

COMMENT ON COLUMN crypto_transaction.attested_cancel_condition IS 'A threshold condition that, when fulfilled, allows a client to determine, in a cryptographically provable manner, if this crypto-transaction has been CANCELLED';

COMMENT ON COLUMN crypto_transaction.attested_expire_condition IS 'A threshold condition that, when fulfilled, allows a client to determine, in a cryptographically provable manner, if this crypto-transaction has been EXPIRED';

COMMENT ON COLUMN crypto_transaction.published_fulfillment IS 'An optional fulfillment that is only present if this crypto-transaction is in the EXECUTED state';

COMMENT ON COLUMN crypto_transaction.attestation_fulfillment IS 'An optional fulfillment that is only present if this crypto-transaction is in the EXECUTED or CANCELLED state';

COMMENT ON COLUMN crypto_transaction.finalized_dttm_hint IS 'Hint about when this cryptotransaction was finalized';

COMMENT ON COLUMN crypto_transaction.expires_dttm IS 'This validator is authoritative for this value. The validator signs this value once a fulfillment has been received, so care should be taken to ensure this value matches the value found in the fulfillment.';

COMMENT ON COLUMN crypto_transaction.created_dttm IS 'Time that the crypto_transaction record was created';

COMMENT ON COLUMN crypto_transaction.modified_dttm IS 'Time that the crypto_transaction record was last modified';

COMMENT ON COLUMN crypto_transaction.version IS 'Internal value used by the database to update the crypto_transaction record';

CREATE INDEX txns_exp_dttm_status_lease_id ON crypto_transaction(expires_dttm, state_hint);

-- Changeset db/validator/changelogs/base/changelog.xml::oracle_sequence::ripple
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/scheduler/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/scheduler/changelogs/base/changelog.xml::Create quartz tables::imalygin
CREATE TABLE QRTZ_JOB_DETAILS (SCHED_NAME VARCHAR(100) NOT NULL, JOB_NAME VARCHAR(150) NOT NULL, JOB_GROUP VARCHAR(150) NOT NULL, DESCRIPTION VARCHAR(250), JOB_CLASS_NAME VARCHAR(250) NOT NULL, IS_DURABLE BOOLEAN NOT NULL, IS_NONCONCURRENT BOOLEAN NOT NULL, IS_UPDATE_DATA BOOLEAN NOT NULL, REQUESTS_RECOVERY BOOLEAN NOT NULL, JOB_DATA BYTEA, CONSTRAINT QRTZ_JOB_DETAILS_PKEY PRIMARY KEY (SCHED_NAME, JOB_NAME, JOB_GROUP));

COMMENT ON TABLE QRTZ_JOB_DETAILS IS 'Stores detailed information for every configured Job';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.JOB_NAME IS 'Job name';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.JOB_GROUP IS 'Group name for this Job';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.DESCRIPTION IS 'Job description';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.JOB_CLASS_NAME IS 'Class name associated with Job';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.IS_DURABLE IS 'Boolean indicator for Job if it is durable';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.IS_NONCONCURRENT IS 'Boolean indicator for Job if it is non-concurrent';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.IS_UPDATE_DATA IS 'Boolean indicator for Job if it updates data';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.REQUESTS_RECOVERY IS 'Boolean indicator for Job if it can request recovery';

COMMENT ON COLUMN QRTZ_JOB_DETAILS.JOB_DATA IS 'Blob that represents the Job definition string';

CREATE TABLE QRTZ_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, JOB_NAME VARCHAR(150) NOT NULL, JOB_GROUP VARCHAR(150) NOT NULL, DESCRIPTION VARCHAR(250), NEXT_FIRE_TIME BIGINT, PREV_FIRE_TIME BIGINT, PRIORITY INTEGER, TRIGGER_STATE VARCHAR(16) NOT NULL, TRIGGER_TYPE VARCHAR(8) NOT NULL, START_TIME BIGINT NOT NULL, END_TIME BIGINT, CALENDAR_NAME VARCHAR(200), MISFIRE_INSTR SMALLINT, JOB_DATA BYTEA, CONSTRAINT QRTZ_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_TRIGGERS IS 'Stores information about configured triggers';

COMMENT ON COLUMN QRTZ_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_TRIGGERS.TRIGGER_NAME IS 'Trigger name';

COMMENT ON COLUMN QRTZ_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.JOB_NAME IS 'Job name for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.JOB_GROUP IS 'Group name for this Job';

COMMENT ON COLUMN QRTZ_TRIGGERS.DESCRIPTION IS 'Trigger description';

COMMENT ON COLUMN QRTZ_TRIGGERS.NEXT_FIRE_TIME IS 'Next fire time for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.PREV_FIRE_TIME IS 'Last fire time for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.PRIORITY IS 'Priority of this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.TRIGGER_STATE IS 'Current state of Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.TRIGGER_TYPE IS 'Trigger type';

COMMENT ON COLUMN QRTZ_TRIGGERS.START_TIME IS 'Start time for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.END_TIME IS 'End time for this Trigger';

COMMENT ON COLUMN QRTZ_TRIGGERS.CALENDAR_NAME IS 'Calendar name';

COMMENT ON COLUMN QRTZ_TRIGGERS.MISFIRE_INSTR IS 'Misfire instructions';

COMMENT ON COLUMN QRTZ_TRIGGERS.JOB_DATA IS 'Blob that represents the Job definition string';

CREATE TABLE QRTZ_SIMPLE_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, REPEAT_COUNT BIGINT NOT NULL, REPEAT_INTERVAL BIGINT NOT NULL, TIMES_TRIGGERED BIGINT NOT NULL, CONSTRAINT QRTZ_SIMPLE_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_SIMPLE_TRIGGERS IS 'Stores simple triggers, including repeat count, internal, and number of times triggered';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.TRIGGER_NAME IS 'Trigger name';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.REPEAT_COUNT IS 'Number of times the Job should repeat';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.REPEAT_INTERVAL IS 'Amount of time between Job repeats';

COMMENT ON COLUMN QRTZ_SIMPLE_TRIGGERS.TIMES_TRIGGERED IS 'Total number of time this Trigger was invoked';

CREATE TABLE QRTZ_CRON_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, CRON_EXPRESSION VARCHAR(120) NOT NULL, TIME_ZONE_ID VARCHAR(80), CONSTRAINT QRTZ_CRON_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_CRON_TRIGGERS IS 'Stores cron triggers, including cron expression and time zone information';

COMMENT ON COLUMN QRTZ_CRON_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_CRON_TRIGGERS.TRIGGER_NAME IS 'Trigger name';

COMMENT ON COLUMN QRTZ_CRON_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_CRON_TRIGGERS.CRON_EXPRESSION IS 'Cron expression for this Trigger';

COMMENT ON COLUMN QRTZ_CRON_TRIGGERS.TIME_ZONE_ID IS 'Time Zone';

CREATE TABLE QRTZ_SIMPROP_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, STR_PROP_1 VARCHAR(512), STR_PROP_2 VARCHAR(512), STR_PROP_3 VARCHAR(512), INT_PROP_1 INTEGER, INT_PROP_2 INTEGER, LONG_PROP_1 BIGINT, LONG_PROP_2 BIGINT, DEC_PROP_1 numeric(13, 4), DEC_PROP_2 numeric(13, 4), BOOL_PROP_1 BOOLEAN, BOOL_PROP_2 BOOLEAN, CONSTRAINT QRTZ_SIMPROP_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_SIMPROP_TRIGGERS IS 'Stores simple properties related to Triggers';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.TRIGGER_NAME IS 'Trigger name';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.STR_PROP_1 IS 'String property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.STR_PROP_2 IS 'String property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.STR_PROP_3 IS 'String property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.INT_PROP_1 IS 'Integer property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.INT_PROP_2 IS 'Integer property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.LONG_PROP_1 IS 'Long property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.LONG_PROP_2 IS 'Long property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.DEC_PROP_1 IS 'Decimal(13,4) property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.DEC_PROP_2 IS 'Decimal(13,4) property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.BOOL_PROP_1 IS 'Boolean property';

COMMENT ON COLUMN QRTZ_SIMPROP_TRIGGERS.BOOL_PROP_2 IS 'Boolean property';

CREATE TABLE QRTZ_BLOB_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, JOB_DATA BYTEA, CONSTRAINT QRTZ_BLOB_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_BLOB_TRIGGERS IS 'Stores triggers as blobs (used when Quartz users create their own custom trigger types with JDBC; JobStore does not have specific knowledge about how to store instances)';

COMMENT ON COLUMN QRTZ_BLOB_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_BLOB_TRIGGERS.TRIGGER_NAME IS 'Trigger Name';

COMMENT ON COLUMN QRTZ_BLOB_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_BLOB_TRIGGERS.JOB_DATA IS 'Blob that represents the Job definition string';

CREATE TABLE QRTZ_CALENDARS (SCHED_NAME VARCHAR(100) NOT NULL, CALENDAR_NAME VARCHAR(200) NOT NULL, CALENDAR BYTEA NOT NULL, CONSTRAINT QRTZ_CALENDARS_PKEY PRIMARY KEY (SCHED_NAME, CALENDAR_NAME));

COMMENT ON TABLE QRTZ_CALENDARS IS 'Stores Quartz calendar information as blobs';

COMMENT ON COLUMN QRTZ_CALENDARS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_CALENDARS.CALENDAR_NAME IS 'Calendar name';

COMMENT ON COLUMN QRTZ_CALENDARS.CALENDAR IS 'Blob that represents the Calendar definition string';

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (SCHED_NAME VARCHAR(100) NOT NULL, TRIGGER_GROUP VARCHAR(200) NOT NULL, CONSTRAINT QRTZ_PAUSED_TRIGGER_GRPS_PKEY PRIMARY KEY (SCHED_NAME, TRIGGER_GROUP));

COMMENT ON TABLE QRTZ_PAUSED_TRIGGER_GRPS IS 'Stores paused trigger groups';

COMMENT ON COLUMN QRTZ_PAUSED_TRIGGER_GRPS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_PAUSED_TRIGGER_GRPS.TRIGGER_GROUP IS 'Group name for this trigger';

CREATE TABLE QRTZ_FIRED_TRIGGERS (SCHED_NAME VARCHAR(100) NOT NULL, ENTRY_ID VARCHAR(95) NOT NULL, TRIGGER_NAME VARCHAR(150) NOT NULL, TRIGGER_GROUP VARCHAR(150) NOT NULL, INSTANCE_NAME VARCHAR(200) NOT NULL, FIRED_TIME BIGINT NOT NULL, SCHED_TIME BIGINT NOT NULL, PRIORITY INTEGER NOT NULL, STATE VARCHAR(16) NOT NULL, JOB_NAME VARCHAR(150), JOB_GROUP VARCHAR(150), IS_NONCONCURRENT BOOLEAN, REQUESTS_RECOVERY BOOLEAN, CONSTRAINT QRTZ_FIRED_TRIGGERS_PKEY PRIMARY KEY (SCHED_NAME, ENTRY_ID));

COMMENT ON TABLE QRTZ_FIRED_TRIGGERS IS 'Stores status information relating to triggers that have fired and the relevant execution information about the related Job';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.ENTRY_ID IS 'Unique id representing entry of this table';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.TRIGGER_NAME IS 'Trigger name';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.TRIGGER_GROUP IS 'Group name for this Trigger';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.INSTANCE_NAME IS 'Trigger instance name';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.FIRED_TIME IS 'Fired time of Trigger';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.SCHED_TIME IS 'Scheduled time of Trigger';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.PRIORITY IS 'Priority';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.STATE IS 'Trigger state';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.JOB_NAME IS 'Job name';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.JOB_GROUP IS 'Group name for this Job';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.IS_NONCONCURRENT IS 'Boolean indicator for this Job if it is non-concurrent';

COMMENT ON COLUMN QRTZ_FIRED_TRIGGERS.REQUESTS_RECOVERY IS 'Boolean indicator for this Job if is can request recovery';

CREATE TABLE QRTZ_SCHEDULER_STATE (SCHED_NAME VARCHAR(100) NOT NULL, INSTANCE_NAME VARCHAR(200) NOT NULL, LAST_CHECKIN_TIME BIGINT NOT NULL, CHECKIN_INTERVAL BIGINT NOT NULL, CONSTRAINT QRTZ_SCHEDULER_STATE_PKEY PRIMARY KEY (SCHED_NAME, INSTANCE_NAME));

COMMENT ON TABLE QRTZ_SCHEDULER_STATE IS 'Stores information about the state of the Scheduler and other Scheduler instances (if used within a cluster)';

COMMENT ON COLUMN QRTZ_SCHEDULER_STATE.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_SCHEDULER_STATE.INSTANCE_NAME IS 'Instance name';

COMMENT ON COLUMN QRTZ_SCHEDULER_STATE.LAST_CHECKIN_TIME IS 'Last check-in time';

COMMENT ON COLUMN QRTZ_SCHEDULER_STATE.CHECKIN_INTERVAL IS 'Check-in interval';

CREATE TABLE QRTZ_LOCKS (SCHED_NAME VARCHAR(100) NOT NULL, LOCK_NAME VARCHAR(40) NOT NULL, CONSTRAINT QRTZ_LOCKS_PKEY PRIMARY KEY (SCHED_NAME, LOCK_NAME));

COMMENT ON TABLE QRTZ_LOCKS IS 'Stores pessimistic lock information for the application (if pessimistic locking is used)';

COMMENT ON COLUMN QRTZ_LOCKS.SCHED_NAME IS 'Scheduler name';

COMMENT ON COLUMN QRTZ_LOCKS.LOCK_NAME IS 'Lock name';

-- Changeset db/scheduler/changelogs/base/changelog.xml::Create foreign key constraints::imalygin
ALTER TABLE QRTZ_CRON_TRIGGERS ADD CONSTRAINT FK_CRON_TRGS_QRTZ_TRGS FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE QRTZ_SIMPLE_TRIGGERS ADD CONSTRAINT FK_SIMPLE_TRGS_QRTZ_TRGS FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE QRTZ_SIMPROP_TRIGGERS ADD CONSTRAINT FK_SIMPROP_TRGS_QRTZ_TRGS FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE QRTZ_TRIGGERS ADD CONSTRAINT FK_TRGS_QRTZ_JOB_DETAILS FOREIGN KEY (SCHED_NAME, JOB_NAME, JOB_GROUP) REFERENCES QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP) ON UPDATE NO ACTION ON DELETE CASCADE;

-- Changeset db/scheduler/changelogs/base/changelog.xml::Create indices::imalygin
CREATE INDEX IDX_QRTZ_T_J ON QRTZ_TRIGGERS(SCHED_NAME, JOB_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_T_JG ON QRTZ_TRIGGERS(SCHED_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_T_C ON QRTZ_TRIGGERS(SCHED_NAME, CALENDAR_NAME);

CREATE INDEX IDX_QRTZ_T_G ON QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_GROUP);

CREATE INDEX IDX_QRTZ_T_STATE ON QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_T_N_STATE ON QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_T_N_G_STATE ON QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_T_NEXT_FIRE_TIME ON QRTZ_TRIGGERS(SCHED_NAME, NEXT_FIRE_TIME);

CREATE INDEX IDX_QRTZ_T_NFT_ST ON QRTZ_TRIGGERS(SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);

CREATE INDEX IDX_QRTZ_T_NFT_MISFIRE ON QRTZ_TRIGGERS(SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME);

CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE ON QRTZ_TRIGGERS(SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE_GRP ON QRTZ_TRIGGERS(SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_FT_TRIG_INST_NAME ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, INSTANCE_NAME);

CREATE INDEX IDX_QRTZ_FT_INST_JOB_REQ_RCVRY ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);

CREATE INDEX IDX_QRTZ_FT_J_G ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, JOB_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_FT_JG ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_FT_T_G ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);

CREATE INDEX IDX_QRTZ_FT_TG ON QRTZ_FIRED_TRIGGERS(SCHED_NAME, TRIGGER_GROUP);

-- Changeset db/scheduler/changelogs/1.20.0/changelog.xml::Add human-readable job definition::imalygin
ALTER TABLE QRTZ_JOB_DETAILS ADD JOB_DEFINITION_READ_ONLY VARCHAR(4000);

COMMENT ON COLUMN QRTZ_JOB_DETAILS.JOB_DEFINITION_READ_ONLY IS 'Readable job definitions (otherwise it would be Blob)';

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/ripplenetprotocol/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/ripplenetprotocol/changelogs/base/changelog.xml::create initial tables::Service Archetype
CREATE TABLE RIPPLENET_ROUTE (ID BIGSERIAL NOT NULL, RIPPLENET_ROUTE_ID UUID NOT NULL, DESTINATION_ADDRESS VARCHAR(255) NOT NULL, RESULT VARCHAR(255) NOT NULL, ROUTE_STORE OID NOT NULL, ROUTE_EXPIRY TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT RIPPLENET_ROUTE_PKEY PRIMARY KEY (ID), UNIQUE (RIPPLENET_ROUTE_ID));

COMMENT ON TABLE RIPPLENET_ROUTE IS 'Stores Ripplenet Route';

COMMENT ON COLUMN RIPPLENET_ROUTE.ID IS 'Database primary key';

COMMENT ON COLUMN RIPPLENET_ROUTE.RIPPLENET_ROUTE_ID IS 'Unique Id representing a RippleNet Route';

COMMENT ON COLUMN RIPPLENET_ROUTE.DESTINATION_ADDRESS IS 'Address of the RippleNet Route destination';

COMMENT ON COLUMN RIPPLENET_ROUTE.RESULT IS 'Representation of the Path found during pathFinding (path-complete, path-cycle, path-incomplete, path-timed-out, path-incompatible-features)';

COMMENT ON COLUMN RIPPLENET_ROUTE.ROUTE_STORE IS 'Blob representation of RippleNet Route';

COMMENT ON COLUMN RIPPLENET_ROUTE.ROUTE_EXPIRY IS 'Expiry time for RippleNet Route';

COMMENT ON COLUMN RIPPLENET_ROUTE.CREATED_DTTM IS 'Time that the RippleNet Route record was created';

COMMENT ON COLUMN RIPPLENET_ROUTE.MODIFIED_DTTM IS 'Time that the RippleNet Route record was last modified';

COMMENT ON COLUMN RIPPLENET_ROUTE.VERSION IS 'Internal value used by the database to update the RippleNet Route record';

CREATE TABLE WORKFLOW_STRATEGY (ID BIGSERIAL NOT NULL, WORKFLOW_STRATEGY_ID UUID NOT NULL, WORKFLOW_ENTITY_ID UUID NOT NULL, WORKFLOW_TYPE VARCHAR(255) NOT NULL, FEATURE VARCHAR(255) NOT NULL, STRATEGY_VERSION SMALLINT NOT NULL, RIPPLENET_ROUTE_ID UUID NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT WORKFLOW_STRATEGY_PKEY PRIMARY KEY (ID), UNIQUE (WORKFLOW_STRATEGY_ID));

COMMENT ON TABLE WORKFLOW_STRATEGY IS 'Stores a Workflow Strategy';

COMMENT ON COLUMN WORKFLOW_STRATEGY.ID IS 'Database primary key';

COMMENT ON COLUMN WORKFLOW_STRATEGY.WORKFLOW_STRATEGY_ID IS 'Id of the Workflow Strategy Record';

COMMENT ON COLUMN WORKFLOW_STRATEGY.WORKFLOW_ENTITY_ID IS 'Id of the Entity that uses the Workflow Strategy';

COMMENT ON COLUMN WORKFLOW_STRATEGY.WORKFLOW_TYPE IS 'Type of Entity that uses the Workflow Strategy (PAYMENT, QUOTE, TRANSFER)';

COMMENT ON COLUMN WORKFLOW_STRATEGY.FEATURE IS 'Feature version used by entity';

COMMENT ON COLUMN WORKFLOW_STRATEGY.STRATEGY_VERSION IS 'Strategy Version stored for the workflow';

COMMENT ON COLUMN WORKFLOW_STRATEGY.RIPPLENET_ROUTE_ID IS 'Id of the RippleNet Route that stores the Feature Ballots';

COMMENT ON COLUMN WORKFLOW_STRATEGY.CREATED_DTTM IS 'Time that the Workflow Strategy record was created';

COMMENT ON COLUMN WORKFLOW_STRATEGY.MODIFIED_DTTM IS 'Time that the Workflow Strategy record was modified';

COMMENT ON COLUMN WORKFLOW_STRATEGY.VERSION IS 'Internal value used by the database to update the Workflow Strategy record';

CREATE INDEX DESTINATION_ADDRESS_EXPIRY_IDX ON RIPPLENET_ROUTE(DESTINATION_ADDRESS, ROUTE_EXPIRY);

CREATE UNIQUE INDEX WF_ENTITY_ID_TYPE_IDX ON WORKFLOW_STRATEGY(WORKFLOW_ENTITY_ID, WORKFLOW_TYPE);

-- Changeset db/ripplenetprotocol/changelogs/base/changelog.xml::oracle_sequence::ripplenet_protocol
-- Changeset db/ripplenetprotocol/changelogs/1.201.0/changelog.xml::Create Tables for EventTrail::RN Core team
CREATE TABLE EVENT_TRAIL (ID BIGSERIAL NOT NULL, ENTITY_ID UUID NOT NULL, MESSAGE_SENDER VARCHAR(100) NOT NULL, FEATURE_NAME VARCHAR(100) NOT NULL, RIPPLENET_MESSAGE_TYPE SMALLINT NOT NULL, MESSAGE_ACTION SMALLINT NOT NULL, MESSAGE_DETAILS VARCHAR(500), BACKGROUND_JOB_STATUS SMALLINT NOT NULL, CREATED_AT TIMESTAMP WITHOUT TIME ZONE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT EVENT_TRAIL_PKEY PRIMARY KEY (ID));

CREATE UNIQUE INDEX ID_FN_MSG_TYPE_AND_ACTION_IDX ON EVENT_TRAIL(FEATURE_NAME, ENTITY_ID, RIPPLENET_MESSAGE_TYPE, MESSAGE_ACTION, MESSAGE_SENDER);

CREATE INDEX FN_TYPE_ACTION_CREATED_ELI_IDX ON EVENT_TRAIL(CREATED_AT, MESSAGE_SENDER, FEATURE_NAME, RIPPLENET_MESSAGE_TYPE, MESSAGE_ACTION, BACKGROUND_JOB_STATUS);

-- Changeset db/ripplenetprotocol/changelogs/1.201.0/changelog.xml::oracle_sequence::RN Core team
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/audit-trail/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/audit-trail/changelogs/base/changelog.xml::create initial tables::Service Archetype
CREATE TABLE AUDIT_RECORD (ID BIGSERIAL NOT NULL, EVENT_ID UUID NOT NULL, ACTOR VARCHAR(255) NOT NULL, ACTION VARCHAR(255) NOT NULL, DOMAIN SMALLINT NOT NULL, METADATA VARCHAR(255), MESSAGE VARCHAR(1024), AUDIT_LEVEL SMALLINT, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT AUDIT_RECORD_PKEY PRIMARY KEY (ID));

COMMENT ON TABLE AUDIT_RECORD IS 'Stores information of audit trail in xCurrent system';

COMMENT ON COLUMN AUDIT_RECORD.ID IS 'Database primary key';

COMMENT ON COLUMN AUDIT_RECORD.EVENT_ID IS 'UUID representing a unique id for each audit event';

COMMENT ON COLUMN AUDIT_RECORD.ACTOR IS 'String representation of the one who took action';

COMMENT ON COLUMN AUDIT_RECORD.ACTION IS 'String representation of action being taken.';

COMMENT ON COLUMN AUDIT_RECORD.DOMAIN IS 'Represents audit event belong to which domain. Possible values [USER_MANAGEMENT, CONFIG_MANAGEMENT, OTHER]';

COMMENT ON COLUMN AUDIT_RECORD.METADATA IS 'Represents subtle information about the actor. ex: ip address, request url';

COMMENT ON COLUMN AUDIT_RECORD.MESSAGE IS 'Represents actual message that represent the audit event.';

COMMENT ON COLUMN AUDIT_RECORD.AUDIT_LEVEL IS 'Represents Audit level. Possible values are [INFO, WARN, ERROR]';

COMMENT ON COLUMN AUDIT_RECORD.CREATED_DTTM IS 'Time that the audit event record was created';

COMMENT ON COLUMN AUDIT_RECORD.MODIFIED_DTTM IS 'Time that the audit event record was last modified';

COMMENT ON COLUMN AUDIT_RECORD.VERSION IS 'Internal value used by the database to update the audit event version';

CREATE INDEX IDX_AUDIT_RECORD ON AUDIT_RECORD(ACTOR, ACTION, DOMAIN, AUDIT_LEVEL);

-- Changeset db/audit-trail/changelogs/base/changelog.xml::oracle_sequence::RNC team
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ./db/xcurrent/changelog-master.xml
-- Ran at: 9/24/19 12:00 PM
-- Against: null@offline:postgresql?version=9.4?version=9&changeLogFile=/var/folders/91/lqbmp8px1sd543z8btcmgkw80000gp/T/liquibase2sql.jHm7mxnE/databasechangelog_postgresql.csv
-- Liquibase version: 3.6.2
-- *********************************************************************

-- Changeset db/xcurrent/changelogs/base/changelog.xml::create initial tables::Service Archetype
CREATE TABLE USER_ROLE (ID BIGSERIAL NOT NULL, UUID UUID NOT NULL, NAME VARCHAR(255) NOT NULL, DISPLAY_NAME VARCHAR(50) NOT NULL, USER_PRIVILEGES VARCHAR(1024), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT USER_ROLE_PKEY PRIMARY KEY (ID), UNIQUE (NAME));

COMMENT ON COLUMN USER_ROLE.USER_PRIVILEGES IS 'A space-separated collection of privileges given to this userRole.';

CREATE TABLE USER_ACCOUNT (ID BIGSERIAL NOT NULL, UUID UUID NOT NULL, FIRSTNAME VARCHAR(255) NOT NULL, LASTNAME VARCHAR(255), EMAIL VARCHAR(255) NOT NULL, HASHED_PASSWORD VARCHAR(255) NOT NULL, HASHED_2FA_SECRET VARCHAR(255) NOT NULL, ENABLED BOOLEAN, ISUSING2FA BOOLEAN, RESETPASSWORD BOOLEAN, ACCOUNT_STATUS SMALLINT NOT NULL, ACCOUNT_CREATOR VARCHAR(255), ACCOUNT_UPDATER VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT USER_ACCOUNT_PKEY PRIMARY KEY (ID), UNIQUE (EMAIL));

CREATE TABLE USERS_ROLES (USER_ID BIGINT NOT NULL, ROLE_ID BIGINT NOT NULL, CONSTRAINT USERS_ROLES_PKEY PRIMARY KEY (USER_ID, ROLE_ID), CONSTRAINT ROLE_ID FOREIGN KEY (ROLE_ID) REFERENCES USER_ROLE(ID), CONSTRAINT USER_ID FOREIGN KEY (USER_ID) REFERENCES USER_ACCOUNT(ID));

CREATE TABLE OAUTH_CLIENT_DETAILS (ID BIGSERIAL NOT NULL, CLIENT_ID VARCHAR(255) NOT NULL, CLIENT_SECRET VARCHAR(255), RESOURCE_IDS VARCHAR(255), SCOPE VARCHAR(4000) NOT NULL, AUTHORIZED_GRANT_TYPES VARCHAR(512) NOT NULL, WEB_SERVER_REDIRECT_URI VARCHAR(512), AUTHORITIES VARCHAR(255), ACCESS_TOKEN_VALIDITY VARCHAR(255) DEFAULT '3600' NOT NULL, REFRESH_TOKEN_VALIDITY VARCHAR(255) DEFAULT '0', ADDITIONAL_INFORMATION VARCHAR(4000), AUTOAPPROVE VARCHAR(4000), CONSTRAINT OAUTH_CLIENT_DETAILS_PKEY PRIMARY KEY (ID), UNIQUE (CLIENT_ID));

CREATE TABLE CLIENTS_LEDGER (ID BIGSERIAL NOT NULL, CLIENT_ID VARCHAR(255) NOT NULL, LEDGER_ACCOUNT_ID BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT CLIENTS_LEDGER_PKEY PRIMARY KEY (ID));

CREATE TABLE USAGE_SCHEDULER_REPORT (ID BIGSERIAL NOT NULL, REPORT_START_TIME TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, REPORT_END_TIME TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, PAYLOAD TEXT, STATUS SMALLINT NOT NULL, VERSION SMALLINT NOT NULL, CONSTRAINT USAGE_SCHEDULER_REPORT_PKEY PRIMARY KEY (ID));

CREATE TABLE SYSTEM_CONFIG (ID BIGSERIAL NOT NULL, LOGIN_ATTEMPT BIGINT NOT NULL, MIN_LOWERCASE_CHAR BIGINT NOT NULL, MIN_UPPERCASE_CHAR BIGINT NOT NULL, MIN_NUMERIC_CHAR BIGINT NOT NULL, MIN_SPECIAL_CHAR BIGINT NOT NULL, MIN_PASSWORD_LENGTH BIGINT NOT NULL, MAX_PASSWORD_LENGTH BIGINT NOT NULL, MFA_ENABLED BOOLEAN NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, VERSION SMALLINT NOT NULL, CREATED_BY VARCHAR(255) NOT NULL, MODIFIED_BY VARCHAR(255) NOT NULL, CONSTRAINT SYSTEM_CONFIG_PKEY PRIMARY KEY (ID));

CREATE TABLE SYSTEM_CONFIG_AUD (ID BIGINT, MFA_ENABLED BOOLEAN NOT NULL, LOGIN_ATTEMPT BIGINT NOT NULL, MIN_LOWERCASE_CHAR BIGINT NOT NULL, MIN_UPPERCASE_CHAR BIGINT NOT NULL, MIN_NUMERIC_CHAR BIGINT NOT NULL, MIN_SPECIAL_CHAR BIGINT NOT NULL, MIN_PASSWORD_LENGTH BIGINT NOT NULL, MAX_PASSWORD_LENGTH BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, CREATED_BY VARCHAR(255) NOT NULL, MODIFIED_BY VARCHAR(255) NOT NULL, REVTYPE SMALLINT NOT NULL, REV INTEGER NOT NULL);

CREATE TABLE REVINFO (REV SERIAL NOT NULL, REVTSTMP BIGINT, CONSTRAINT REVINFO_PKEY PRIMARY KEY (REV));

CREATE INDEX IDX_CLIENT_ID ON CLIENTS_LEDGER(CLIENT_ID);

CREATE INDEX IDX_LEDGER_ACCOUNT_ID ON CLIENTS_LEDGER(LEDGER_ACCOUNT_ID);

CREATE INDEX IDX_REPORT_END_TIME ON USAGE_SCHEDULER_REPORT(REPORT_END_TIME);

-- Changeset db/xcurrent/changelogs/base/changelog.xml::audit-tables::nbondugula
CREATE TABLE USER_ACCOUNT_AUD (ID BIGINT NOT NULL, UUID UUID NOT NULL, FIRSTNAME VARCHAR(255) NOT NULL, LASTNAME VARCHAR(255), EMAIL VARCHAR(255) NOT NULL, HASHED_PASSWORD VARCHAR(255) NOT NULL, HASHED_2FA_SECRET VARCHAR(255) NOT NULL, ENABLED BOOLEAN, ISUSING2FA BOOLEAN, RESETPASSWORD BOOLEAN, ACCOUNT_STATUS SMALLINT NOT NULL, ACCOUNT_CREATOR VARCHAR(255), ACCOUNT_UPDATER VARCHAR(255), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, REVTYPE SMALLINT NOT NULL, REV INTEGER NOT NULL);

CREATE TABLE USER_ROLE_AUD (ID BIGINT NOT NULL, UUID UUID NOT NULL, NAME VARCHAR(255) NOT NULL, DISPLAY_NAME VARCHAR(50) NOT NULL, USER_PRIVILEGES VARCHAR(1024), CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, REVTYPE SMALLINT NOT NULL, REV INTEGER NOT NULL);

COMMENT ON COLUMN USER_ROLE_AUD.USER_PRIVILEGES IS 'A space-separated collection of privileges given to this userRole.';

CREATE TABLE USERS_ROLES_AUD (USER_ID BIGINT NOT NULL, ROLE_ID BIGINT NOT NULL, REVTYPE SMALLINT NOT NULL, REV INTEGER NOT NULL);

CREATE TABLE CLIENTS_LEDGER_AUD (ID BIGINT NOT NULL, CLIENT_ID VARCHAR(255) NOT NULL, LEDGER_ACCOUNT_ID BIGINT NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL, REVTYPE SMALLINT NOT NULL, REV INTEGER NOT NULL);

-- Changeset db/xcurrent/changelogs/base/changelog.xml::hibernate_sequence::kjakkula
CREATE SEQUENCE hibernate_sequence START WITH 20000 INCREMENT BY 1;

-- Changeset db/xcurrent/changelogs/base/changelog.xml::oracle_sequence::xcurrent
-- Changeset db/xcurrent/changelogs/base/changelog.xml::SETUP_INITIAL_DATA::chinmay
-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO USER_ROLE (UUID, NAME, DISPLAY_NAME, USER_PRIVILEGES, CREATED_DTTM, MODIFIED_DTTM, VERSION) VALUES ('4aed7c6b-bc9b-4b28-bd59-cf4116eaef3b', 'PAYMENT_USER', 'Payments User', 'system_settings:read payments:read quotes:read quote_collections:return quote_collections:write payments:accept payments:lock payments:reject payments:settle payments:finalize payments:fail payments:label payments:node_status fxrates:read fxrates:write fee:read fee:write accounts:read accounts:write monitor:balances transfers:read transfers:label transfers:write user:read keys:read keys:write peers:config payments:complete quote_collections:read exchange_transfers:write exchange_transfers_quote:write exchange_transfers:read exchange_transfers_complete:write account_liquidity:config request_for_payment:write request_for_payment:accept request_for_payment:fail request_for_payment:read', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1'),('23294a2a-4459-4966-9ae0-2e1d88ebc59a', 'USER_ADMIN', 'User Admin', 'user:read user:write user_settings:write system_settings:read', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1'),('40fc904b-f4ed-4be8-9116-98ec86aa501d', 'SYSTEM_ADMIN', 'System Admin', 'system_settings:read system_settings:write password_settings:read password_settings:write user:read scheduler:write payments:config', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1'),('b7775c4e-8ace-45af-a8e6-ab6da81128df', 'MONITOR_PAYMENT_USER', 'Monitor Payments User', 'system_settings:read payments:read fxrates:read fee:read accounts:read monitor:balances transfers:read user:read exchange_transfers:read system_settings:read statement:read quotes:read quote_collections:read', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1');

-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO SYSTEM_CONFIG (LOGIN_ATTEMPT, MIN_LOWERCASE_CHAR, MIN_UPPERCASE_CHAR, MIN_NUMERIC_CHAR, MIN_SPECIAL_CHAR, MIN_PASSWORD_LENGTH, MAX_PASSWORD_LENGTH, VERSION, CREATED_BY, MODIFIED_BY, CREATED_DTTM, MODIFIED_DTTM, MFA_ENABLED) VALUES ('3', '2', '2', '2', '1', '8', '15', '1', 'system', 'system', '2018-08-23T20:04:15', '2018-08-23T20:04:15', 'false');

-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO USER_ACCOUNT (UUID, FIRSTNAME, LASTNAME, EMAIL, HASHED_PASSWORD, HASHED_2FA_SECRET, ENABLED, ISUSING2FA, RESETPASSWORD, ACCOUNT_STATUS, ACCOUNT_CREATOR, ACCOUNT_UPDATER, CREATED_DTTM, MODIFIED_DTTM, VERSION) VALUES ('27de472f-3efa-46d5-b5d6-aaddf9cf454d', 'Bob', 'Admin', 'bob@test.com', '$2a$11$M65Vhco3TEpiYT.Npz0KdeWPcxkQXOP0AP5BzgiJCFxcnD1OTgWRe', 'SD2VVQHTOULDZB6N7AYIKZAMG3LTRWQG', 'true', 'false', 'true', '1', 'admin@xcurrent.com', 'admin@xcurrent.com', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1'),('0319bff0-e3d1-4bd3-b873-54b70c3e3fa8', 'Alice', 'Admin', 'alice@test.com', '$2a$11$M65Vhco3TEpiYT.Npz0KdeWPcxkQXOP0AP5BzgiJCFxcnD1OTgWRe', '6MWMCNS6BN4KVVXNF6B7PYDOFMUCFWAO', 'true', 'false', 'true', '1', 'admin@xcurrent.com', 'admin@xcurrent.com', '2018-08-23T20:04:15', '2018-08-23T20:04:15', '1');

-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO USERS_ROLES (USER_ID, ROLE_ID) VALUES ('1', '1'),('1', '2'),('1', '3'),('1', '4'),('2', '1'),('2', '2'),('2', '3'),('2', '4');

-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO OAUTH_CLIENT_DETAILS (CLIENT_ID, CLIENT_SECRET, RESOURCE_IDS, SCOPE, AUTHORIZED_GRANT_TYPES, WEB_SERVER_REDIRECT_URI, AUTHORITIES, ACCESS_TOKEN_VALIDITY, REFRESH_TOKEN_VALIDITY, ADDITIONAL_INFORMATION, AUTOAPPROVE) VALUES ('ui_implicit', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'keys:read,keys:write,system_settings:read,system_settings:write,peers:config,account_liquidity:config,payments:read,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:complete,payments:fail,payments:label,payments:node_status,monitor:balances,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,transfers:read,transfers:write,transfers:label,user:read,user:write,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,user_settings:write,password_settings:read,password_settings:write,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read,payments:config', 'implicit', 'http://localhost:9000/login/callback', 'ADMIN', '900', '0', '{"description":"Test client for testing the OAuth2 implicit grant flow."}', 'true'),('payment_user_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'keys:read,keys:write,payments:read,payments:config,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:label,payments:node_status,payments:complete,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,monitor:balances,transfers:read,transfers:label,transfers:write,user:read,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,account_liquidity:config,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read', 'client_credentials', '', 'PAYMENT_USER', '3600', '0', '{"description":"client for payment user role."}', 'system_settings:read'),('user_admin_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'user:read,user:write,user_settings:write', 'client_credentials', '', 'USER_ADMIN', '3600', '0', '{"description":"client for user_admin role."}', 'system_settings:read'),('system_admin_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'system_settings:read,password_settings:read,password_settings:write,user:read,scheduler:write,payments:config', 'client_credentials', '', 'SYSTEM_ADMIN', '3600', '0', '{"description":"client for system_admin role."}', 'system_settings:read'),('monitor_payment_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'payments:read,fxrates:read,fee:read,accounts:read,monitor:balances,transfers:read,user:read,exchange_transfers:read,statement:read,quotes:read,quote_collections:read', 'client_credentials', '', 'MONITOR_PAYMENT_USER', '3600', '0', '{"description":"client for monitor_payment role."}', 'system_settings:read');

-- Changeset db/xcurrent/changelogs/base/changelog.xml::oracle_seq_generator::xcurrent
-- Changeset db/xcurrent/changelogs/base/changelog.xml::add-columns-usage-scheduler-report::mdevidi
ALTER TABLE USAGE_SCHEDULER_REPORT ADD REPORT_ID VARCHAR(255) NOT NULL;

ALTER TABLE USAGE_SCHEDULER_REPORT ADD REPORT_TYPE SMALLINT NOT NULL;

-- Changeset db/xcurrent/liquidity/changelogs/base/changelog.xml::create initial tables::xcurrent
CREATE TABLE ACC_LIQUIDITY_RELATIONSHIP (ID BIGSERIAL NOT NULL, LIQUIDITY_RELATIONSHIP_ID UUID NOT NULL, FROM_ACCOUNT VARCHAR(255) NOT NULL, TO_ACCOUNT VARCHAR(255) NOT NULL, SOURCE_CURRENCY CHAR(3) NOT NULL, DESTINATION_CURRENCY CHAR(3) NOT NULL, ACTIVE BOOLEAN DEFAULT FALSE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT ACC_LIQUIDITY_RELATIONSHIP_PKEY PRIMARY KEY (ID), UNIQUE (LIQUIDITY_RELATIONSHIP_ID));

CREATE TABLE LIQUIDITY_PATH (ID BIGSERIAL NOT NULL, ACCOUNT_LIQUIDITY_PATH_ID UUID NOT NULL, SOURCE_ACCOUNT VARCHAR(255) NOT NULL, DESTINATION_ACCOUNT VARCHAR(255) NOT NULL, SOURCE_CURRENCY CHAR(3) NOT NULL, DESTINATION_CURRENCY CHAR(3) NOT NULL, PATH_TYPE SMALLINT NOT NULL, ACTIVE BOOLEAN DEFAULT FALSE NOT NULL, CREATED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, MODIFIED_DTTM TIMESTAMP WITHOUT TIME ZONE NOT NULL, CONSTRAINT LIQUIDITY_PATH_PKEY PRIMARY KEY (ID), UNIQUE (ACCOUNT_LIQUIDITY_PATH_ID));

CREATE TABLE PATH_RELATIONSHIP_MAPPING (ACCOUNT_LIQUIDITY_PATH_ID BIGINT NOT NULL, ACCNT_LIQUIDITY_RELATION_ID BIGINT NOT NULL, CONSTRAINT PATH_RELATIONSHIP_MAPPING_PKEY PRIMARY KEY (ACCOUNT_LIQUIDITY_PATH_ID, ACCNT_LIQUIDITY_RELATION_ID), CONSTRAINT FK_LIQUIDITY_RELATIONSHIP FOREIGN KEY (ACCNT_LIQUIDITY_RELATION_ID) REFERENCES ACC_LIQUIDITY_RELATIONSHIP(ID), CONSTRAINT FK_LIQUIDITY_PATH FOREIGN KEY (ACCOUNT_LIQUIDITY_PATH_ID) REFERENCES LIQUIDITY_PATH(ID));

CREATE INDEX IDX_LIQ_PATH_DSTACC_TYPE ON LIQUIDITY_PATH(DESTINATION_ACCOUNT, PATH_TYPE);

CREATE INDEX IDX_PATH_REL_MAP_ACC_REL_ID ON PATH_RELATIONSHIP_MAPPING(ACCNT_LIQUIDITY_RELATION_ID);

-- Changeset db/xcurrent/liquidity/changelogs/base/changelog.xml::oracle_sequence::xcurrent
-- Changeset db/xcurrent/changelogs/4.1.0/changelog.xml::Super User Client for 4.1.0::reed
-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO OAUTH_CLIENT_DETAILS (CLIENT_ID, CLIENT_SECRET, RESOURCE_IDS, SCOPE, AUTHORIZED_GRANT_TYPES, WEB_SERVER_REDIRECT_URI, AUTHORITIES, ACCESS_TOKEN_VALIDITY, REFRESH_TOKEN_VALIDITY, ADDITIONAL_INFORMATION, AUTOAPPROVE) VALUES ('super_user_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'quotes:read,quote_collections:read,quote_collections:write,quote_collections:return,payments:read,payments:config,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:complete,payments:label,payments:node_status,monitor:balances,heartbeat:check,statement:read,scheduler:write,usage_report:generate,fxrates:read,fxrates:write,fee:read,fee:write,keys:write,keys:read,accounts:read,accounts:write,transfers:write,transfers:read,transfers:label,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers_complete:write,exchange_transfers:read,system_settings:read,system_settings:write,account_liquidity:config,peers:config,user:write,user:read,user_settings:write,password_settings:read,password_settings:write,xvia:write', 'client_credentials', '', 'SUPER_USER', '3600', '0', '{"description":"client for super user."}', 'system_settings:read');

-- Changeset db/xcurrent/changelogs/4.1.0/changelog.xml::PaymentUserClient for 4.1.0::lreyes
-- Changeset db/xcurrent/changelogs/4.1.0/changelog.xml::Bca Clients for 4.1.0::nbondugula
-- WARNING The following SQL may change each run and therefore is possibly incorrect and/or invalid:
INSERT INTO OAUTH_CLIENT_DETAILS (CLIENT_ID, CLIENT_SECRET, RESOURCE_IDS, SCOPE, AUTHORIZED_GRANT_TYPES, WEB_SERVER_REDIRECT_URI, AUTHORITIES, ACCESS_TOKEN_VALIDITY, REFRESH_TOKEN_VALIDITY, ADDITIONAL_INFORMATION, AUTOAPPROVE) VALUES ('v3_operator_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'v3:admin,keys:read,keys:write,payments:read,payments:config,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:label,payments:node_status,payments:complete,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,monitor:balances,transfers:read,transfers:label,transfers:write,user:read,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,account_liquidity:config,request_for_payment:write,request_for_payment:complete,request_for_payment:fail,request_for_payment:read', 'client_credentials', '', 'PAYMENT_USER', '3600', '0', '{"description":"client for payment and bca role."}', 'system_settings:read'),('bca_client', '$2a$11$whTwnO8.ScFtCx12y6R9/OgxtyZgBXgjAtnfbZMk.xxQsAhY7vPUe', 'xcurrent', 'system_settings:read', 'client_credentials', '', 'SYSTEM_ADMIN', '3600', '0', '{"description":"client required for bca."}', 'system_settings:read');

-- Changeset db/xcurrent/changelogs/4.2.0/changelog.xml::Adding client:read and admin privillege::jjanardhanan
UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'quotes:read,quote_collections:read,quote_collections:write,quote_collections:return,payments:read,payments:config,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:complete,payments:label,payments:node_status,monitor:balances,heartbeat:check,statement:read,scheduler:write,usage_report:generate,fxrates:read,fxrates:write,fee:read,fee:write,keys:write,keys:read,accounts:read,accounts:write,transfers:write,transfers:read,transfers:label,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers_complete:write,exchange_transfers:read,system_settings:read,system_settings:write,account_liquidity:config,peers:config,user:write,user:read,user_settings:write,password_settings:read,password_settings:write,xvia:write,clients:read,clients:admin,ledger_clients:admin,ledger_clients:read,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read' WHERE CLIENT_ID='super_user_client';

-- Changeset db/xcurrent/changelogs/4.2.0/changelog.xml::Removing non-null constraints from CLIENTS_LEDGER_AUD table::ztotta
ALTER TABLE CLIENTS_LEDGER_AUD ALTER COLUMN  LEDGER_ACCOUNT_ID DROP NOT NULL;

ALTER TABLE CLIENTS_LEDGER_AUD ALTER COLUMN  CLIENT_ID DROP NOT NULL;

-- Changeset db/xcurrent/changelogs/4.2.0/changelog.xml::Adding fk constraint to CLIENTS_LEDGER columns CLIENT_ID::ztotta
ALTER TABLE CLIENTS_LEDGER ADD CONSTRAINT fk_client_id FOREIGN KEY (CLIENT_ID) REFERENCES OAUTH_CLIENT_DETAILS (CLIENT_ID);

-- Changeset db/xcurrent/changelogs/4.3.1/changelog.xml::Adding LOGIN_ATTEMPTS and IP_ADDRESS columns to USER_ACCOUNT and USER_ACCOUNT_AUD tables::awang
ALTER TABLE USER_ACCOUNT ADD LOGIN_ATTEMPTS INTEGER;

ALTER TABLE USER_ACCOUNT ADD IP_ADDRESS VARCHAR(255);

ALTER TABLE USER_ACCOUNT ADD LAST_FAILED_LOGIN TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE USER_ACCOUNT_AUD ADD LOGIN_ATTEMPTS INTEGER;

ALTER TABLE USER_ACCOUNT_AUD ADD IP_ADDRESS VARCHAR(255);

ALTER TABLE USER_ACCOUNT_AUD ADD LAST_FAILED_LOGIN TIMESTAMP WITHOUT TIME ZONE;

-- Changeset db/xcurrent/changelogs/4.3.1/changelog.xml::add non null constraint to loginAttempts::awang
UPDATE USER_ACCOUNT SET LOGIN_ATTEMPTS = '0' WHERE LOGIN_ATTEMPTS IS NULL;

ALTER TABLE USER_ACCOUNT ALTER COLUMN  LOGIN_ATTEMPTS SET NOT NULL;

UPDATE USER_ACCOUNT_AUD SET LOGIN_ATTEMPTS = '0' WHERE LOGIN_ATTEMPTS IS NULL;

ALTER TABLE USER_ACCOUNT_AUD ALTER COLUMN  LOGIN_ATTEMPTS SET NOT NULL;

-- Changeset db/xcurrent/changelogs/4.3.1/changelog.xml::Adding admin_user:read, user:write, and admin_user:write to admin clients and roles::lreyes
UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'keys:read,keys:write,system_settings:read,system_settings:write,peers:config,account_liquidity:config,payments:read,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:complete,payments:fail,payments:label,payments:node_status,monitor:balances,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,transfers:read,transfers:write,transfers:label,user:read,user:write,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,user_settings:write,password_settings:read,password_settings:write,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read,payments:config,admin_user:read,admin_user:write' WHERE CLIENT_ID='ui_implicit';

UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'user:read,user:write,user_settings:write,admin_user:read,admin_user:write' WHERE CLIENT_ID='user_admin_client';

UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'system_settings:read,password_settings:read,password_settings:write,user:read,scheduler:write,payments:config,admin_user:read,user:write' WHERE CLIENT_ID='system_admin_client';

UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'quotes:read,quote_collections:read,quote_collections:write,quote_collections:return,payments:read,payments:config,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:complete,payments:label,payments:node_status,monitor:balances,heartbeat:check,statement:read,scheduler:write,usage_report:generate,fxrates:read,fxrates:write,fee:read,fee:write,keys:write,keys:read,accounts:read,accounts:write,transfers:write,transfers:read,transfers:label,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers_complete:write,exchange_transfers:read,system_settings:read,system_settings:write,account_liquidity:config,peers:config,user:write,user:read,user_settings:write,password_settings:read,password_settings:write,xvia:write,clients:read,clients:admin,ledger_clients:admin,ledger_clients:read,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read,admin_user:read,admin_user:write' WHERE CLIENT_ID='super_user_client';

UPDATE USER_ROLE SET USER_PRIVILEGES = 'user:read user:write user_settings:write system_settings:read admin_user:read admin_user:write' WHERE NAME='USER_ADMIN';

UPDATE USER_ROLE SET USER_PRIVILEGES = 'system_settings:read system_settings:write password_settings:read password_settings:write user:read scheduler:write payments:config admin_user:read user:write' WHERE NAME='SYSTEM_ADMIN';

-- Changeset db/xcurrent/changelogs/4.3.1/changelog.xml::Adding user:write to all clients and roles::lreyes
UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'keys:read,keys:write,payments:read,payments:config,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:label,payments:node_status,payments:complete,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,monitor:balances,transfers:read,transfers:label,transfers:write,user:read,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,account_liquidity:config,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read,user:write' WHERE CLIENT_ID='payment_user_client';

UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'payments:read,fxrates:read,fee:read,accounts:read,monitor:balances,transfers:read,user:read,exchange_transfers:read,statement:read,quotes:read,quote_collections:read,user:write' WHERE CLIENT_ID='monitor_payment_client';

UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'v3:admin,keys:read,keys:write,payments:read,payments:config,quotes:read,quote_collections:return,quote_collections:write,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:label,payments:node_status,payments:complete,fxrates:read,fxrates:write,fee:read,fee:write,accounts:read,accounts:write,monitor:balances,transfers:read,transfers:label,transfers:write,user:read,quote_collections:read,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers:read,exchange_transfers_complete:write,account_liquidity:config,request_for_payment:write,request_for_payment:complete,request_for_payment:fail,request_for_payment:read,user:write' WHERE CLIENT_ID='v3_operator_client';

UPDATE USER_ROLE SET USER_PRIVILEGES = 'system_settings:read payments:read quotes:read quote_collections:return quote_collections:write payments:accept payments:lock payments:reject payments:settle payments:finalize payments:fail payments:label payments:node_status fxrates:read fxrates:write fee:read fee:write accounts:read accounts:write monitor:balances transfers:read transfers:label transfers:write user:read keys:read keys:write peers:config payments:complete quote_collections:read exchange_transfers:write exchange_transfers_quote:write exchange_transfers:read exchange_transfers_complete:write account_liquidity:config request_for_payment:write request_for_payment:accept request_for_payment:fail request_for_payment:read user:write' WHERE NAME='PAYMENT_USER';

UPDATE USER_ROLE SET USER_PRIVILEGES = 'system_settings:read payments:read fxrates:read fee:read accounts:read monitor:balances transfers:read user:read exchange_transfers:read system_settings:read statement:read quotes:read quote_collections:read user:write' WHERE NAME='MONITOR_PAYMENT_USER';

-- Changeset db/xcurrent/changelogs/4.4.0/changelog.xml::Removing oauth super user client's scheduler:write, usage_report:generate and heartbeat:check privilege::mdevidi
UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'quotes:read,quote_collections:read,quote_collections:write,quote_collections:return,payments:read,payments:config,payments:accept,payments:lock,payments:reject,payments:settle,payments:finalize,payments:fail,payments:complete,payments:label,payments:node_status,monitor:balances,statement:read,fxrates:read,fxrates:write,fee:read,fee:write,keys:write,keys:read,accounts:read,accounts:write,transfers:write,transfers:read,transfers:label,exchange_transfers:write,exchange_transfers_quote:write,exchange_transfers_complete:write,exchange_transfers:read,system_settings:read,system_settings:write,account_liquidity:config,peers:config,user:write,user:read,user_settings:write,password_settings:read,password_settings:write,xvia:write,clients:read,clients:admin,ledger_clients:admin,ledger_clients:read,request_for_payment:write,request_for_payment:accept,request_for_payment:fail,request_for_payment:read,admin_user:read,admin_user:write' WHERE CLIENT_ID='super_user_client';

-- Changeset db/xcurrent/changelogs/4.4.0/changelog.xml::Removing oauth system admin client's scheduler:write privilege::mdevidi
UPDATE OAUTH_CLIENT_DETAILS SET SCOPE = 'system_settings:read,password_settings:read,password_settings:write,user:read,payments:config,admin_user:read,user:write' WHERE CLIENT_ID='system_admin_client';

-- Changeset db/xcurrent/changelogs/4.4.0/changelog.xml::Removing system admin role's scheduler:write privilege::mdevidi
UPDATE USER_ROLE SET USER_PRIVILEGES = 'system_settings:read system_settings:write password_settings:read password_settings:write user:read payments:config admin_user:read user:write' WHERE NAME='SYSTEM_ADMIN';

