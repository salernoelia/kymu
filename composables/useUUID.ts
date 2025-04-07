import { v4, v7 } from "uuid";

export const useUUID = () => {
    const isValidUUID = (uuid: string) => {
        const regex =
            /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
        return regex.test(uuid);
    };

    const generateV4 = () => {
        return v4();
    };

    const generateV7 = () => {
        return v7();
    };

    return {
        isValidUUID,
        generateV4,
        generateV7,
    };
};
