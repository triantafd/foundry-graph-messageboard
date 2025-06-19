import { NewMessage } from "../generated/MessageBoard/MessageBoard"
import { Message } from "../generated/schema"

export function handleNewMessage(event: NewMessage): void {
    let entity = new Message(event.transaction.hash.toHex())
    entity.sender = event.params.sender
    entity.message = event.params.message
    entity.timestamp = event.params.timestamp
    entity.save()
}
