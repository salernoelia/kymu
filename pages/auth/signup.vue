<template>
  <div class="flex justify-center items-center h-screen">
    <div
      class="max-w-sm w-full flex flex-col items-center bg-white p-8 pt-10 pb-10 rounded-md shadow-md gap-4"
    >
      <h2 class="text-2xl font-bold">Sign Up</h2>

      <p
        v-if="errorMessage"
        class="text-error"
      >
        {{ errorMessage }}
      </p>

      <!-- User Type Selection -->
      <PrimitivesSelect
        v-model="selectedUserType"
        :options="UserTypeOptions"
        placeholder="Select user type"
      />

      <!-- Form Inputs -->
      <PrimitivesInput
        v-model="firstName"
        type="text"
        placeholder="Enter your first name"
      />
      <PrimitivesInput
        v-model="lastName"
        type="text"
        placeholder="Enter your last name"
      />
      <PrimitivesInput
        v-model="email"
        type="email"
        placeholder="Enter your email"
      />
      <PrimitivesInput
        v-model="phoneNum"
        type="text"
        placeholder="Enter your phone number"
      />
      <PrimitivesInput
        v-model="street"
        type="text"
        placeholder="Enter your street"
      />
      <PrimitivesInput
        v-model="streetNumber"
        type="text"
        placeholder="Enter your street number"
      />
      <PrimitivesInput
        v-model="zipCode"
        type="text"
        placeholder="Enter your ZIP code"
      />
      <PrimitivesInput
        v-model="city"
        type="text"
        placeholder="Enter your city"
      />
      <PrimitivesInput
        v-model="country"
        type="text"
        placeholder="Enter your country"
      />
      <PrimitivesInput
        v-model="password"
        type="password"
        placeholder="Enter your password"
      />

      <!-- Submit Button -->
      <PrimitivesButton
        @click="signUp"
        variant="tertiary"
      >
        Sign Up
      </PrimitivesButton>

      <!-- Toggle Forms -->
      <div class="text-center">
        <span class="text-gray-600">Already have an account?</span>
        <NuxtLink
          :to="localePath('/auth/login')"
          class="text-gray-700 hover:text-black hover:underline cursor-pointer"
        >
          {{ $t("login") }}
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  layout: "auth",
});

const { t, locale } = useI18n({
  useScope: "local",
});

const localePath = useLocalePath();
const client = useSupabaseClient();
const email = ref("");
const password = ref("");
const errorMessage = ref("");
const selectedUserType = ref("");
const phoneNum = ref("");
const firstName = ref("");
const lastName = ref("");
const street = ref("");
const streetNumber = ref("");
const zipCode = ref("");
const city = ref("");
const country = ref("");

const UserTypeOptions = [
  { label: "Patient", value: "patient" },
  { label: "Therapist", value: "therapist" },
];

async function signUp() {
  try {
    if (
      !email.value ||
      !password.value ||
      !selectedUserType.value ||
      !firstName.value ||
      !lastName.value ||
      !street.value ||
      !streetNumber.value ||
      !zipCode.value ||
      !city.value ||
      !country.value
    ) {
      errorMessage.value = "Please fill in all required fields.";
      return;
    }

    if (
      !UserTypeOptions.some((option) => option.value === selectedUserType.value)
    ) {
      errorMessage.value = "Invalid user type selected.";
      return;
    }

    if (password.value.length < 8) {
      errorMessage.value = "Password must be at least 8 characters long.";
      return;
    }

    const { error } = await client.auth.signUp({
      email: email.value,
      password: password.value,
      phone: phoneNum.value,
      options: {
        data: {
          first_name: firstName.value,
          last_name: lastName.value,
          user_type: selectedUserType.value,
          street: street.value,
          street_number: streetNumber.value,
          zip_code: zipCode.value,
          city: city.value,
          country: country.value,
          language: locale.value,
        },
      },
    });

    if (error) throw error;
    errorMessage.value = "Please check your email to verify your account.";
  } catch (error) {
    errorMessage.value = error.message;
  }
}
</script>
