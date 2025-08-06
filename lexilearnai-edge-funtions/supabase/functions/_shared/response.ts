export interface BaseResponse<T> {
    response: {
        code: number;
        message: string;
        path: string;
    };
    data: T;
   
}
