import Commandant
import Result

public func <| <T, ClientError>(
    mode: CommandMode,
    argument: (CommandMode) -> Result<T, CommandantError<ClientError>>
  ) -> Result<T, CommandantError<ClientError>> {
  return argument(mode)
}
