<template>
  <div class="flex justify-center items-center h-screen">
    <div class="max-w-sm w-full">
      <h2 class="text-2xl font-bold mb-4">Sign Up</h2>

      <select
        v-model="selectedUserType"
        required="true"
        type="user-type"
        :placeholder="t('selectUserTypePlaceholder')"
      >
        <option
          v-for="option in UserTypeOptions"
          :key="option.value"
          :value="option.value"
        >
          {{ option.label }}
        </option>
      </select>
      <!-- form content -->
      <form
        label="First Name"
        name="name"
        class="py-2"
        required="true"
      >
        <input
          v-model="firstName"
          type="name"
          placeholder="Enter your first name"
          color="grey"
        />
      </form>

      <form
        label="Last Name"
        name="name"
        class="py-2"
        required="true"
      >
        <input
          v-model="lastName"
          type="name"
          placeholder=" Enter your last name"
          color="grey"
        />
      </form>

      <form
        label="Email"
        name="email"
        class="py-2"
        required="true"
      >
        <input
          v-model="email"
          type="email"
          placeholder="Enter your email"
          color="grey"
        />
      </form>

      <form
        label="Phone Number"
        name="phone"
        class="py-2"
      >
        <input
          v-model="phoneNum"
          type="tel"
          placeholder="Enter your phone number"
          color="grey"
        />
      </form>

      <form
        label="Street"
        name="street"
        class="py-2"
        required
      >
        <input
          v-model="street"
          placeholder="Enter your street"
          color="grey"
        />
      </form>

      <form
        label="Street Number"
        name="streetNumber"
        class="py-2"
        required
      >
        <input
          v-model="streetNumber"
          placeholder="Enter your street number"
          color="grey"
        />
      </form>

      <form
        label="ZIP Code"
        name="zipCode"
        class="py-2"
        required
      >
        <input
          v-model="zipCode"
          placeholder="Enter your ZIP code"
          color="grey"
        />
      </form>

      <form
        label="City"
        name="city"
        class="py-2"
        required
      >
        <input
          v-model="city"
          placeholder="Enter your city"
          color="grey"
        />
      </form>

      <form
        label="Country"
        name="country"
        class="py-2"
        required
      >
        <input
          v-model="country"
          placeholder="Enter your country"
          color="grey"
        />
      </form>

      <form
        label="Password"
        name="password"
        class="py-2"
        required="true"
      >
        <input
          v-model="password"
          type="password"
          placeholder="Enter your password"
          color="grey"
        />
      </form>

      <!-- submit btn -->
      <div class="flex justify-center items-center pt-4 w-full">
        <nuxt-link
          @click="signUp"
          class="w-full bg-blue-500 hover:bg-blue-700 text-white py-2 px-4 rounded cursor-pointer"
          >Sign Up</nuxt-link
        >
      </div>

      <!-- toggle forms -->
      <div class="mt-4 text-center">
        <span class="text-gray-500"> Already have an account? </span>
        <NuxtLink
          :to="localePath('/login')"
          class="text-gray-500 hover:text-black hover:underline cursor-pointer"
        >
          {{ $t("login") }}
        </NuxtLink>
      </div>

      <UAlert
        v-if="errorMessage"
        icon="i-heroicons-information-circle-20-solid"
        :title="errorMessage"
        class="mt-4 border-solid border-2 border-red-500 text-red-500"
      />
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
const successMessage = ref("");
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
  { label: "Caregiver", value: "caregiver" },
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
    successMessage.value = "Please check your email to verify your account.";
  } catch (error) {
    errorMessage.value = error.message;
  }
}
</script>
