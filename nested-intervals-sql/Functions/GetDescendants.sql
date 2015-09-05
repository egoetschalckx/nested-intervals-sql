CREATE FUNCTION GetDescendants(
	@parentNodeId BIGINT,
	@numGenerations INT
) returns @childtable TABLE (
	node_id BIGINT NOT NULL,
	name NVARCHAR(64) NOT NULL,
	nv BIGINT NOT NULL, 
	dv BIGINT NOT NULL,
	snv BIGINT NOT NULL,
	sdv BIGINT NOT NULL,
	depth INT NOT NULL,
	parent_node_id BIGINT NOT NULL)
AS
begin
	if @parentNodeId = NULL
		SET @parentNodeId = 0

	DECLARE @nvp BIGINT
	DECLARE @dvp BIGINT
	DECLARE @snvp BIGINT
	DECLARE @sdvp BIGINT
	DECLARE @parentDepth INT

	-- read the parent's fractions
	-- todo: what does this do if parent no exist
	SELECT
		@nvp = n.[nv],
		@dvp = n.[dv],
		@snvp = n.[snv],
		@sdvp = n.[sdv],
		@parentDepth = n.[depth]
	FROM [Node] AS n
	WHERE n.[node_id] = @parentNodeId

	insert into @childtable
	SELECT n.node_id, n.name, n.nv, n.dv, n.snv, n.sdv, n.depth, n.parent_node_id
	FROM [Node] AS n
	WHERE
		(cast(n.[nv] AS FLOAT) / n.[dv]) > (cast(@nvp AS FLOAT) / @dvp) 
		and 
		(cast(n.[nv] AS FLOAT) / n.[dv]) < (cast(@snvp AS FLOAT) / @sdvp) 
		and (@numGenerations = -1 or n.[depth]  <= @parentDepth + @numGenerations)
	--ORDER BY n.[depth] ASC, n.[parent_node_id] ASC--, (cast(n.[nv] AS FLOAT) / n.[dv]) ASC

	RETURN
END
