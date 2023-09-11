CREATE TABLE test_table
(
    timestamp DateTime,
    log string,
)
ENGINE = MergeTree
PRIMARY KEY (timestamp)