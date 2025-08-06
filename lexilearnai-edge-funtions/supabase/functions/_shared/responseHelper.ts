
import type { BaseResponse, ErrorPayload } from "./response.ts";

export function sendSuccess<T>({
    data,
    message = "Success",
    code = 200,
    path,
}: {
    data: T;
    message: string;
    code: number;
    path: string;
}): Response {
    const payload: BaseResponse<T> = {
        response: { code, message, path },
        data: data,
    };
    return new Response(JSON.stringify(payload), {
        status: code,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
    });
}

export function sendError({
    message,
    code,
    path,
}: {
    message: string;
    code: number;
    details?: ErrorPayload["details"];
    path: string;
}): Response {
    const payload: BaseResponse<null> = {
        response: { code, message, path },
        data: {},
    };
    return new Response(JSON.stringify(payload), {
        status: code,
        headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
    });
}
