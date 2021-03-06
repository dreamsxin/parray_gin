/* parray_gin.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION parray_gin" to load this file. \quit

-- must be run as a normal user

-- GIN support

create or replace function parray_gin_compare(internal, internal) returns internal
 as 'MODULE_PATHNAME' language C immutable strict;

create or replace function parray_gin_extract_value(internal, internal, internal) returns internal
 as 'MODULE_PATHNAME' language C immutable strict;

create or replace function parray_gin_extract_query(internal, internal, internal, internal, internal, internal, internal) returns internal
 as 'MODULE_PATHNAME' language C immutable strict;

create or replace function parray_gin_consistent(internal, internal, internal, internal, internal, internal, internal, internal) returns internal
 as 'MODULE_PATHNAME' language C immutable strict;



-- GIN operator class

-- partial operators <@@ and @@>
--   text[] op text[]
--   arr @> array['foo'] - strict contains
--   arr @@> array['ba'] - partial contains

create or replace function parray_contains_partial(_text, _text) returns bool
 as 'MODULE_PATHNAME' language C immutable strict;
comment on function parray_contains_partial(_text,_text) is 'text array contains compared by partial';

create or replace function parray_contained_partial(_text, _text) returns bool
 as 'MODULE_PATHNAME' language C immutable strict;
comment on function parray_contained_partial(_text,_text) is 'text array contained compared by partial';

create or replace function parray_contains_strict(_text, _text) returns bool
 as 'MODULE_PATHNAME' language C immutable strict;
comment on function parray_contains_strict(_text,_text) is 'text array contains compared by strict';

create or replace function parray_contained_strict(_text, _text) returns bool
 as 'MODULE_PATHNAME' language C immutable strict;
comment on function parray_contained_strict(_text,_text) is 'text array contained compared by strict';

-- strict contains
create operator @> (
  leftarg = _text,
  rightarg = _text,
  procedure = parray_contains_strict,
	commutator = '<@',
  restrict = contsel,
  join = contjoinsel
);

create operator <@ (
  leftarg = _text,
  rightarg = _text,
  procedure = parray_contained_strict,
	commutator = '@>',
  restrict = contsel,
  join = contjoinsel
);

-- partial contains
create operator @@> (
  leftarg = _text,
  rightarg = _text,
  procedure = parray_contains_partial,
	commutator = '<@@',
  restrict = contsel,
  join = contjoinsel
);

create operator <@@ (
  leftarg = _text,
  rightarg = _text,
  procedure = parray_contained_partial,
	commutator = '@@>',
  restrict = contsel,
  join = contjoinsel
);

-- operator class

create operator class parray_gin_ops
for type _text using gin
as
	operator	7		@> (_text,_text),   -- strict
	operator	8		<@ (_text,_text),   -- strict
	operator	9		@@> (_text,_text),  -- partial
	operator	10	<@@ (_text,_text),  -- partial
	function	1	parray_gin_compare(internal, internal),
	function	2	parray_gin_extract_value(internal, internal, internal),
	function	3	parray_gin_extract_query(internal, internal, internal, internal, internal, internal, internal),
	function	4	parray_gin_consistent(internal, internal, internal, internal, internal, internal, internal, internal),
--	function	5	parray_gin_compare_partial(internal, internal, internal, internal),
	storage		int4;

