package xiaozhi.modules.sys.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import xiaozhi.modules.sys.enums.ServerActionEnum;

/**
 * DTO for sending a python server action
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmitSeverActionDTO
{
    @Schema(description = "Target ws address")
    @NotEmpty(message = "Target ws address cannot be empty")
    private String targetWs;

    @Schema(description = "Specified action")
    @NotNull(message = "Action cannot be empty")
    private ServerActionEnum action;
}
