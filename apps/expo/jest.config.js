const androidPreset = require('jest-expo/android/jest-preset');

/** @type {import('jest').Config} */
module.exports = {
  ...androidPreset,
  transform: {
    ...androidPreset.transform,
    '\\.[jt]sx?$': [
      'babel-jest',
      {
        presets: [require.resolve('babel-preset-expo')],
        caller: {
          name: 'metro',
          bundler: 'metro',
          platform: 'android',
        },
      },
    ],
  },
  setupFilesAfterEnv: [...(androidPreset.setupFilesAfterEnv ?? []), '<rootDir>/jest.setup.ts'],
  clearMocks: true,
  testPathIgnorePatterns: [...(androidPreset.testPathIgnorePatterns ?? []), '<rootDir>/[.]expo/'],
};
