CREATE FUNCTION GetAncestors(
	@nodeId BIGINT,
	@numGenerations INT
) RETURNS @ancestortable TABLE (
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
	DECLARE @ancnv BIGINT = 0
	DECLARE @ancdv BIGINT = 1
	DECLARE @ancsnv BIGINT = 1
	DECLARE @ancsdv BIGINT = 0
	DECLARE @div BIGINT
	DECLARE @mod BIGINT
	DECLARE @numerator BIGINT
	DECLARE @denominator BIGINT
	DECLARE @depth INT

	SELECT
		@numerator = n.[nv],
		@denominator = n.[dv],
		@depth = n.[depth]
	FROM [Node] AS n
	WHERE n.[node_id] = @nodeId
	
	-- todo: loop appears to include node itself, but maybe the math is slightly wrong and it shouldnt? blocked it with a where
	WHILE @numerator > 0 and @denominator > 0
	BEGIN
		SET @div = @numerator / @denominator
		SET @mod = @numerator % @denominator
		SET @ancnv = @ancnv + @div * @ancsnv
		SET @ancdv = @ancdv + @div * @ancsdv
		SET @ancsnv = @ancnv + @ancsnv
		SET @ancsdv = @ancdv + @ancsdv
		
		INSERT INTO @ancestortable
		SELECT [node_id], [name], [nv], [dv], [snv], [sdv], [depth], [parent_node_id]
		FROM [Node]
		WHERE 
			[nv] = @ancnv 
			AND [dv] = @ancdv
			AND [node_id] <> @nodeId
			AND (@numGenerations = -1 OR [depth] >= @depth - @numGenerations)
		
		SET @numerator = @mod
		
		IF @numerator <> 0
		BEGIN
			SET @denominator = @denominator % @mod
			IF @denominator = 0
			BEGIN
				SET @denominator = 1
			END
		END
	END
	RETURN
END
