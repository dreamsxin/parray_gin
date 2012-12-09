set client_min_messages to 'error';
drop extension if exists "parray_gin" cascade;
create extension "parray_gin";
set client_min_messages to 'notice';

\t on
\pset format unaligned

-- t
select array['foo', 'bar', 'baz'] @> array['foo'];
-- t
select array['foo', 'bar', 'baz'] @> array['foo', 'bar'];
-- t
select array['foo', 'bar', 'baz'] @> array['baz', 'foo'];
-- f
select array['foo', 'bar', 'baz'] @> array['qux'];
-- t
select array['foo', 'bar', 'baz'] @> array[]::text[];
-- t
select array[]::text[] @> array[]::text[];
-- f
select array[]::text[] @> array['qux'];

-- t
select array['foo', 'bar', 'baz'] @@> array['foo'];
-- t
select array['foo', 'bar', 'baz'] @@> array['foo', 'bar'];
-- t
select array['foo', 'bar', 'baz'] @@> array['baz', 'foo'];
-- f
select array['foo', 'bar', 'baz'] @@> array['qux'];
-- t
select array['foo', 'bar', 'baz'] @@> array[]::text[];
-- t
select array[]::text[] @> array[]::text[];
-- f
select array[]::text[] @> array['qux'];

-- t
select array['foo', 'bar', 'baz'] @@> array['fo'];
-- t
select array['foo', 'bar', 'baz'] @@> array['ba'];
-- t
select array['foo', 'bar', 'baz'] @@> array['b'];
-- t
select array['foo', 'bar', 'baz'] @@> array[''];
-- f
select array['foo', 'bar', 'baz'] @@> array['baq'];
-- t
select array['foo', 'foobar', 'baz'] @@> array['foo'];

-- t
select array['foo', 'boo', 'baz'] @@> array['oo'];
-- t
select array['foo', 'boo', 'baz'] @@> array['ba', 'fo'];
-- f
select array['foo', 'boo', 'baz'] @@> array['ooz'];
-- t
select array['food', 'booze', 'baz'] @@> array['ooz'];


-- t
select array['fo'] <@@ array['foo', 'bar', 'baz'];
-- t
select array['ba', 'fo'] <@@ array['foo', 'bar', 'baz'];
-- t
select array['ba'] <@@ array['foo', 'bar', 'baz'];
-- t
select array['b'] <@@ array['foo', 'bar', 'baz'];
-- t
select array[''] <@@ array['foo', 'bar', 'baz'];
-- f
select array['baq'] <@@ array['foo', 'bar', 'baz'];
-- t
select array['foo'] <@@ array['foo', 'foobar', 'baz'];

-- t
select array['oo'] <@@ array['foo', 'boo', 'baz'];
-- f
select array['ooz'] <@@ array['foo', 'boo', 'baz'];
-- t
select array['ooz'] <@@ array['food', 'booze', 'baz'];

\t off
\pset format aligned
