import { beforeEach, describe, expect, it, vi } from "vitest";
import { mountSuspended } from "@nuxt/test-utils/runtime";
import { ChartsBar } from "#components";

describe("Bar Chart Component", () => {
    it("can mount BarChart component", async () => {
        const component = await mountSuspended(ChartsBar, {
            props: {
                title: "Test Bar Chart",
            },
        });

        expect(component.text()).toContain("Test Bar Chart");
        expect(component.find(".chart-container").exists()).toBe(true);
    });
});
