﻿CREATE TABLE [Node] (
	[node_id] BIGINT IDENTITY(0, 1),
	[name] NVARCHAR(64) NOT NULL,
	[nv] BIGINT NOT NULL,
	[dv] BIGINT NOT NULL,
	[snv] BIGINT NOT NULL,
	[sdv] BIGINT NOT NULL,
	[depth] INT NOT NULL,
	[parent_node_id] BIGINT NOT NULL
)