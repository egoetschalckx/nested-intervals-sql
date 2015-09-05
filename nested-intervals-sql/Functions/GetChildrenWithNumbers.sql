CREATE FUNCTION GetChildrenWithNumbers(
	@parentNodeId BIGINT
) RETURNS @childtable TABLE (
	node_id BIGINT NOT NULL,
	name NVARCHAR(64) NOT NULL,
	nv BIGINT NOT NULL, 
	dv BIGINT NOT NULL,
	snv BIGINT NOT NULL,
	sdv BIGINT NOT NULL,
	depth INT NOT NULL,
	parent_node_id BIGINT NOT NULL,
	c BIGINT IDENTITY(1, 1))
AS
BEGIN
	IF @parentNodeId = NULL
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

	INSERT INTO @childtable
	SELECT 
		c.[node_id], 
		c.[name], 
		c.[nv], 
		c.[dv], 
		c.[snv], 
		c.[sdv], 
		c.[depth], 
		c.[parent_node_id]
	FROM GetDescendants(@parentNodeId, 1) AS c

	RETURN
END
