CREATE PROCEDURE [dbo].[ResetTree] (
	@numInitialNodes BIGINT = 0
) 
AS
	DELETE FROM [Node]
	DBCC CHECKIDENT ([Node], RESEED, -1)

	INSERT INTO [Node] VALUES ('[reserved]', 2, 1, 3, 1, 0, -1)

	DECLARE @i INT = 0
	DECLARE @newNodeId BIGINT
	WHILE (@i < @numInitialNodes)
	BEGIN
		execute InsertRandomNode  @newNodeId output
		set @i = @i + 1
	END
RETURN
